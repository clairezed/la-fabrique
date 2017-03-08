class Comment < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable

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


  # Associations ===============================================================
  belongs_to :tool
  
  # Callbacks ==================================================================
  validates :content, presence: true

  # Scopes =====================================================================

  scope :by_state, ->(state){ 
    where(state: states.fetch(state.to_sym) )
  }

  
  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_state(params[:by_state]) if params[:by_state].present?

    klass.apply_sorts(params)
  end
  
  # Instance Methods ===========================================================

  private #=====================================================================
  
end
