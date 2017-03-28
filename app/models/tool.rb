class Tool < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include Seoable

  # Nb de jours après sa création pdt lesquels un outil est considéré comme "nouveau"
  NOVELTY_DELAY = 6

   # State machine -------------------------------------------------------------

  include AASM

  # états de publication et validation par l'admin
  #
  enum state: {
    draft:   0, # en attente de validation
    pending:   1, # en attente de validation
    accepted:  2, # accepté
    rejected:  3  # rejeté
  }

  aasm column: :state, enum: true do

    state :draft, initial: true
    state :pending
    state :accepted
    state :rejected

    event :submit do
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

  # Enums ----------------------------------------------------------------------

  enum group_size: {
    size_1:  0, # 2-10
    size_2:  1, # 10-40
    size_3:  2  # + 40
  }

  enum duration: {
    duration_1:   0, # en attente de validation
    duration_2:  1, # accepté
    duration_3:  2,  # rejeté
    duration_4:  3  # rejeté
  }

  enum level: {
    easy:   0, # en attente de validation
    medium: 1, # accepté
    hard:   2  # rejeté
  }

  # enum public: {
  #   young:  0, # en attente de validation
  #   pro:    1, # accepté
  # }

  # enum licence: {
  #   mine:           0, # en attente de validation
  #   known_source:   1, # accepté
  #   unknown_source: 2  # rejeté
  # }


  enum description_type: {
    steps:   0, 
    description: 1
  }
  
  # Associations ===============================================================
  belongs_to :axis
  belongs_to :tool_category
  
  has_many :attachments,
            class_name: :'::Asset::ToolAttachment',
            as:         :assetable,
            dependent:  :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :tool_tags, dependent: :restrict_with_exception
  has_many :tags, through: :tool_tags

  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true


  # Callbacks ==================================================================
  validates :title, presence: true
  validates :group_size, 
            :duration, 
            :level, 
    presence: true

  # Etape 2 du formulaire de création ----------------------------

  validates :goal,
            :teaser,
    presence: true, unless: :new_record?

  private def description_exists?
  # TODO : depend aussi de si c'es step ou desc_type
  return true if self.steps.any? || self.description.present?
    self.errors.add(:description, "doit être renseignée")
    false
  end
  validate :description_exists?, unless: :new_record?

  # validation de présence de axe et catégorie -> directement en base
  
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
                  .where(tt[:tag_id].in(id).and tt[:tool_id].eq(arel_table[:id]))
                  .exists
    where(condition)
  }

  scope :by_state, ->(state){ 
    where(state: states.fetch(state.to_sym) )
  }

  scope :by_format_type, ->(format){
    # pour que le scope fonctionne qu'on renvoit la clé ou le code numerique du format
    format = ::Asset::ToolAttachment.format_types[format] unless format.is_a?(Integer)
    attachment_condition = ::Asset::ToolAttachment.arel_table[:format_type].eq(format)
    link_condition = ::Link.arel_table[:format_type].eq(format)

    eager_load(:attachments).eager_load(:links)
      .where(attachment_condition.or(link_condition))
  }

  scope :by_duration, ->(val){ where(duration: durations.fetch(val.to_sym) ) }
  scope :by_group_size, ->(val){ where(group_size: group_sizes.fetch(val.to_sym) ) }
  scope :by_level, ->(val){ where(level: levels.fetch(val.to_sym) ) }

  # Nouveautés ----------------------------------------------------------------

  scope :recent, -> {
    novelty_datetime = NOVELTY_DELAY.days.ago
    where(arel_table[:created_at].gt(novelty_datetime))
  }
  
  # Class Methods ==============================================================

  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
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

  private #=====================================================================
  
end
