# frozen_string_literal: true

class Theme < ApplicationRecord
  # Configurations =============================================================
  include Sortable
  include Seoable

  acts_as_list

  # Associations ===============================================================

  has_many :axes, dependent: :restrict_with_exception
  has_many :tools, through: :axes
  has_one :basic_page, dependent: :destroy

  # Validations ================================================================
  validates :title, presence: true

  # Callbacks ==================================================================
  private def create_about_page
    page = BasicPage.where(theme_id: self.id, id_key: 'about').first_or_initialize
    page.title = "A propos"
    page.save
  end
  after_create :create_about_page

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

  def self.default
    where(id_key: 'mobility').first || first
  end

  # Instance Methods ===========================================================
end
