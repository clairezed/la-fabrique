# frozen_string_literal: true

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

  # Validations ==================================================================
  validates :content, presence: true

  # Callbacks ==================================================================
  private def notify_admin
    AdminMailer.comment_created(self).deliver_later
  end
  after_create :notify_admin

  # Scopes =====================================================================

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
  }

  scope :by_tool_title, ->(val) {
    joins(:tool).merge(Tool.by_title(val))
  }

  scope :sort_by_tool_title, ->(direction = :asc) {
    joins(:tool).merge(Tool.sort_by_title(direction))
  }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_state(params[:by_state]) if params[:by_state].present?
    klass = klass.by_tool_title(params[:by_tool_title]) if params[:by_tool_title].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================
end
