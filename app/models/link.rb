# frozen_string_literal: true

class Link < ApplicationRecord
  # Configurations =============================================================
  include Sortable
  include FormatTypable

  acts_as_list scope: [:tool_id]

  # Associations ===============================================================

  belongs_to :tool

  # Validations ================================================================
  validates :url,
            # :title,
            presence: true

  private def normalize_url!
    self.url = SanitizationService.normalize_url(url)
  end
  before_validation :normalize_url!, if: :url_changed?

  # Callbacks ==================================================================
  before_validation :set_title

  # Scopes =====================================================================
  scope :by_tool_id, ->(id) {
    return none if id.blank?
    where(tool_id: id)
  }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_tool_id(params[:by_tool_id]) if params[:by_tool_id].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  # true si lien géré par oembed (video, photo, rich..)
  def displayable?
    return !!oembed_resource
  end

  def oembed_resource
    begin
      @oembed_resource ||= OEmbed::Providers.get(self.url)
    rescue OEmbed::NotFound
      return nil
    rescue
      return nil # pour éviter 500 si je bosse en local, hors ligne
    end
  end
  private #=====================================================================

  def set_title
    self.title = url if title.blank?
  end


end
