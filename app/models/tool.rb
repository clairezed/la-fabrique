# frozen_string_literal: true

class Tool < ApplicationRecord
  # Configurations =============================================================
  include Sortable
  include Seoable

  # Nb de jours après sa création pdt lesquels un outil est considéré comme "nouveau"
  NOVELTY_DELAY = 15

  attr_accessor :current_step

  # State machine -------------------------------------------------------------

  include AASM

  # états de publication et validation par l'admin
  #
  enum state: {
    draft:     0, # en attente de validation
    pending:   1, # en attente de validation
    accepted:  2, # accepté
    rejected:  3  # rejeté
  }

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :pending
    state :accepted
    state :rejected

    event :submit, after: [:notify_submission] do
      transitions from: :draft, to: :pending
    end

    event :accept do
      transitions from: :draft, to: :accepted, if: :valid?
      transitions from: :pending, to: :accepted
      transitions from: :rejected, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
      transitions from: :accepted, to: :rejected
    end
  end

  private def notify_submission
    AdminMailer.tool_submitted(self).deliver_later
  end

  # Enums ----------------------------------------------------------------------

  enum group_size: {
    size_1:  0, # 2-10
    size_2:  1, # 10-40
    size_3:  2  # + 40
  }

  enum duration: {
    duration_1:  0, # "5-30"
    duration_2:  1, # "30-60"
    duration_3:  2, # "60-120"
    duration_4:  3  # "120-240"
  }

  enum level: {
    easy:   0, 
    medium: 1, 
    hard:   2  
  }

  enum description_type: {
    description: 0,
    steps:       1
  }

  # Associations ===============================================================
  belongs_to :axis
  belongs_to :tool_category

  has_many :attachments,
           class_name: :'::Asset::ToolAttachment',
           as:         :assetable,
           dependent:  :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :tool_tags, dependent: :destroy
  has_many :tags, through: :tool_tags

  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true

  has_many :training_tools, dependent: :destroy
  has_many :trainings, through: :training_tools

  # Callbacks ==================================================================
  
  # validation de présence de axe et catégorie -> directement en base

  validates :title, presence: true

  # Etape 2 du formulaire de création ----------------------------

  validates :goal,
            :teaser,
            presence: true, unless: :is_step_1?

  private def description_exists?
    return true if (self.steps? and steps.any?) || (self.description? and description.present?)
    errors.add(:description, 'doit être renseignée')
    false
  end
  validate :description_exists?, unless: :is_step_1?

  private def is_step_1?
    current_step.to_i == 1
  end


  # Scopes =====================================================================

  scope :enabled, -> { accepted }

  # Filtres --------------------------------------------------------------------
  scope :by_title, ->(val) {
    val.downcase!
    where(arel_table[:title].matches("%#{val}%"))
  }

  scope :by_axis, ->(val) { where axis: val }
  scope :by_tool_category, ->(val) { where tool_category: val }

  scope :by_tag_ids, ->(id) {
    tt = ToolTag.arel_table
    condition = ToolTag
                .where(tt[:tag_id].in(id).and(tt[:tool_id].eq(arel_table[:id])))
                .exists
    where(condition)
  }

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
  }

  scope :by_format_type, ->(format) {
    # pour que le scope fonctionne qu'on renvoit la clé ou le code numerique du format
    format = ::Asset::ToolAttachment.format_types[format] unless format.is_a?(Integer)
    attachment_condition = ::Asset::ToolAttachment.arel_table[:format_type].eq(format)
    link_condition = ::Link.arel_table[:format_type].eq(format)

    eager_load(:attachments).eager_load(:links)
                            .where(attachment_condition.or(link_condition))
  }

  scope :by_duration, ->(val) { where(duration: durations.fetch(val.to_sym)) }
  scope :by_group_size, ->(val) { where(group_size: group_sizes.fetch(val.to_sym)) }
  scope :by_level, ->(val) { where(level: levels.fetch(val.to_sym)) }

  scope :by_theme, ->(val) {
    joins(:axis).merge(Axis.by_theme(val))
  }

  # Nouveautés ----------------------------------------------------------------

  scope :recent, -> {
    novelty_datetime = NOVELTY_DELAY.days.ago
    where(arel_table[:created_at].gt(novelty_datetime))
  }

  # Class Methods ==============================================================

  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_theme(params[:by_theme]) if params[:by_theme].present?
    klass = klass.by_axis(params[:by_axis]) if params[:by_axis].present?
    klass = klass.by_tool_category(params[:by_tool_category]) if params[:by_tool_category].present?
    klass = klass.by_tag_ids(params[:by_tag_ids]) if params[:by_tag_ids].present?
    klass = klass.by_state(params[:by_state]) if params[:by_state].present?
    klass = klass.by_duration(params[:by_duration]) if params[:by_duration].present?
    klass = klass.by_group_size(params[:by_group_size]) if params[:by_group_size].present?
    klass = klass.by_level(params[:by_level]) if params[:by_level].present?
    klass = klass.by_format_type(params[:by_format_type]) if params[:by_format_type].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  def recent?
    created_at > NOVELTY_DELAY.days.ago
  end

  def random_training
    return nil unless trainings.any?
    @random_training ||= self.trainings.order('random()').first
  end

  def description_for_seo
    self.teaser
  end

  # private #=====================================================================
end
