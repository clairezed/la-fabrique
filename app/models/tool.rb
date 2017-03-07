class Tool < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include Seoable

   # State machine -------------------------------------------------------------

  include AASM

  # états de publication et validation par l'admin
  #
  enum state: {
    pending:   0, # en attente de validation
    accepted:  1, # accepté
    rejected:  2  # rejeté
  }

  aasm column: :state, enum: true do

    state :pending, initial: true
    state :accepted
    state :rejected

    event :accept do
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

  enum public: {
    young:  0, # en attente de validation
    pro:    1, # accepté
  }

  enum licence: {
    mine:           0, # en attente de validation
    known_source:   1, # accepté
    unknown_source: 2  # rejeté
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


  # Callbacks ==================================================================
  validates :title, presence: true
  validates :group_size, :duration, :level, :public, :licence, presence: true

  # validation de présence de axe et catégorie -> directement en base

  private def normalize_url!
    self.source_url = SanitizationService.normalize_url(source_url)
  end
  before_validation :normalize_url!, if: :source_url_changed?
  
  # Scopes =====================================================================
  scope :enabled, -> { accepted }

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
    format_int  = ::Asset::ToolAttachment.format_types[format]
    attachment_condition = ::Asset::ToolAttachment.arel_table[:format_type].eq(format_int)
    #TODO : link_condition
    eager_load(:attachments)
      .where(attachment_condition)
  }

  scope :by_duration, ->(val){ where(duration: durations.fetch(val.to_sym) ) }
  scope :by_group_size, ->(val){ where(group_size: group_sizes.fetch(val.to_sym) ) }
  scope :by_level, ->(val){ where(level: levels.fetch(val.to_sym) ) }
  
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

  private #=====================================================================
  
end
