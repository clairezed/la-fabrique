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

  # Callbacks ==================================================================
  before_validation :set_title
  
  # Scopes =====================================================================
  scope :by_tool_id, -> (id) { where(tool_id: id) }
  
  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    klass = klass.by_tool_id(params[:by_tool_id]) if params[:by_tool_id].present?

    klass.apply_sorts(params)
  end

  # Instance Methods ===========================================================

  private #=====================================================================

  def set_title
    self.title = self.url if self.title.blank?
  end
  
end
