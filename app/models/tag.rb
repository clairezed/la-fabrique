# frozen_string_literal: true

class Tag < ApplicationRecord
  # Configurations =============================================================
  include Sortable
  include Seoable

  acts_as_list

  # Associations ===============================================================

  has_many :tool_tags, dependent: :restrict_with_exception
  has_many :tools, through: :tool_tags

  # Callbacks ==================================================================
  validates :title, presence: true

  # Scopes =====================================================================
  scope :enabled, -> { where(enabled: true) }

  scope :by_title, ->(val) {
    val.downcase!
    where(arel_table[:title].matches("%#{val}%"))
  }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================
end
