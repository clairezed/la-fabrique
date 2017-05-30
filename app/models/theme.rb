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
  private def create_theme_pages
    about_page = BasicPage.where(theme_id: self.id, id_key: 'about').first_or_initialize
    about_page.title = "A propos"
    about_page.save

    cgu_page = BasicPage.where(theme_id: self.id, id_key: 'cgu').first_or_initialize
    cgu_page.title = "Conditions Générales d'Utilisation"
    cgu_page.save

  end
  after_create :create_theme_pages

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
