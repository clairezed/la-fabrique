# frozen_string_literal: true

class Seo < ActiveRecord::Base
  # Configurations =============================================================

  # Associations ===============================================================
  belongs_to :seoable, polymorphic: true, optional: true

  # Callbacks ==================================================================
  validates :slug, presence: true, if: ->(a) { a.param.blank? && a.seoable.try(:title).try(:present?) }

  before_validation :parameterize_slug, if: ->(a) { a.param.blank? }
  before_save :set_title, :set_description

  # Scopes =====================================================================

  # Class Methods ==============================================================

  # Instance Methods ===========================================================

  private #=====================================================================

  # Le slug ne dépasse pas 100 caractères.
  def parameterize_slug
    self.slug = slug.to_s.truncate(100).parameterize
  end

  # Si non défini, le champ SEO title prend les 156 premiers caractères du title.
  def set_title
    self.title = seoable.try(:title) if title.blank?
    self.title = title.to_s.truncate(156)
  end

  # Si non défini, le champ SEO title prend les 156 premiers caractères du title.
  def set_description
    self.description = seoable.try(:description_for_seo) if description.blank?
    self.description = description.to_s.truncate(156)
  end
end
