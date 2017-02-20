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

  # enum duration: {
  #   pending:   0, # en attente de validation
  #   accepted:  1, # accepté
  #   rejected:  2  # rejeté
  # }

  # enum level: {
  #   pending:   0, # en attente de validation
  #   accepted:  1, # accepté
  #   rejected:  2  # rejeté
  # }

  # enum public: {
  #   pending:   0, # en attente de validation
  #   accepted:  1, # accepté
  #   rejected:  2  # rejeté
  # }

  # enum licence: {
  #   pending:   0, # en attente de validation
  #   accepted:  1, # accepté
  #   rejected:  2  # rejeté
  # }
  
  # Associations ===============================================================
  belongs_to :axis
  belongs_to :tool_category

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :axis, presence: true
  
  # Scopes =====================================================================
  scope :enabled, -> { where(enabled: true) }
  scope :by_axis, ->(val) { where theme: val }
  scope :by_title, ->(val) { 
    val.downcase!
    where(arel_table[:title].matches("%#{val}%"))
  }
  
  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_axis(params[:by_axis]) if params[:by_axis].present?

    klass.apply_sorts(params)
  end
  
  # Instance Methods ===========================================================

  private #=====================================================================
  
end
