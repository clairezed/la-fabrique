# frozen_string_literal: true

class TrainingTool < ApplicationRecord
  # Configurations =============================================================
  include Sortable

  acts_as_list scope: [:training_id]

  # Associations ===============================================================

  belongs_to :training
  belongs_to :tool

  # Callbacks ==================================================================
  # validates :title, presence: true

  # Scopes =====================================================================
  # scope :enabled, -> { where(enabled: true) }

  # Class Methods ==============================================================

  # Instance Methods ===========================================================

  # private #=====================================================================
end
