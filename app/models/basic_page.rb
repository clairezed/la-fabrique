# frozen_string_literal: true

class BasicPage < ActiveRecord::Base
  # Configurations =============================================================
  include Sortable
  include Seoable

  acts_as_list

  # Associations ===============================================================

  belongs_to :theme, optional: true

  # Callbacks ==================================================================
  validates :title, presence: true

  # Scopes =====================================================================
  scope :enabled, -> { where(enabled: true) }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_title(params[:by_title]) if params[:by_title].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  def is_about_page?
    self.id_key == 'about'
  end

  def is_mobility_page?
    self.theme == Theme.where(id_key: 'mobility').first
  end

  def is_mobility_about_page?
    is_about_page? && is_mobility_page?
  end

  # private #=====================================================================
end
