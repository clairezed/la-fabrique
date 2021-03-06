# frozen_string_literal: true

class Step < ApplicationRecord
  # Configurations =============================================================
  include Sortable

  acts_as_list scope: [:tool_id]

  # Associations ===============================================================

  belongs_to :tool

  # Callbacks ==================================================================
  validates :description, presence: true

  # Scopes =====================================================================

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    # klass = klass.by_title(params[:by_title]) if params[:by_title].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  # private #=====================================================================
end
