# frozen_string_literal: true

class ToolTag < ApplicationRecord
  # Configurations =============================================================
  include Sortable

  acts_as_list scope: [:tool_id]

  # Associations ===============================================================

  belongs_to :tag
  belongs_to :tool

  # Callbacks ==================================================================
  # validates :title, presence: true

  # Scopes =====================================================================
  # scope :enabled, -> { where(enabled: true) }

  # Class Methods ==============================================================

  # Instance Methods ===========================================================

  # private #=====================================================================
end
