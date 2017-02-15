module Seoable
  extend ActiveSupport::Concern

  included do 
    has_one :seo, as: :seoable, dependent: :destroy
    accepts_nested_attributes_for :seo

    delegate :slug, to: :seo
    delegate :title, :keywords, :description, to: :seo, prefix: true

    validates :seo, presence: true
    before_validation :init_slug, on: :create

    def to_param
      "#{self.slug}-#{self.id}"
    end

    def self.from_param( param )
      find( param.to_s[/\d+\Z/] )
    end

  end

  private


  # Si non défini à la création, le slug correspond aux 100 premiers caractères du title.
  # On doit le mettre ici (et non dans le model Seo) car la relation n'est pas encore 
  # existante pour pouvoir récupérer le title
  def init_slug
    self.build_seo if self.seo.blank?
    self.seo.slug = self.title.to_s.truncate(100) if self.slug.blank?
  end

end