# frozen_string_literal: true

class Axis < ApplicationRecord
  # Configurations =============================================================
  include Sortable
  include Seoable

  acts_as_list

  # Associations ===============================================================
  belongs_to :theme
  has_many :tools, dependent: :restrict_with_exception

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :theme, presence: true

  # Scopes =====================================================================
  scope :enabled, -> { where(enabled: true) }
  scope :by_theme, ->(val) { where theme: val }
  scope :by_title, ->(val) {
    val.downcase!
    where(arel_table[:title].matches("%#{val}%"))
  }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_theme(params[:by_theme]) if params[:by_theme].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  # private #=====================================================================
end
