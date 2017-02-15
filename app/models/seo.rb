class Seo < ActiveRecord::Base
  # Configurations =============================================================

  # Associations ===============================================================
  belongs_to :seoable, polymorphic: true, optional: true

  # Callbacks ==================================================================
  validates :slug, presence: true, if: -> (a) {a.param.blank?}

  before_validation :parameterize_slug, if: -> (a) {a.param.blank?}
  before_save :set_title

  # Scopes =====================================================================
  
  # Class Methods ==============================================================

  # Instance Methods ===========================================================

  private #=====================================================================

  # Le slug ne dépasse pas 100 caractères.
  def parameterize_slug
    self.slug = self.slug.to_s.truncate(100).parameterize
  end


  # Si non défini, le champ SEO title prend les 156 premiers caractères du title.
  def set_title
    self.title = self.seoable.try(:title) if self.title.blank?
    self.title = self.title.to_s.truncate(156)
  end


end
