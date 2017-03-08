class Link < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include FormatTypable

  acts_as_list scope: [:tool_id]
  
  # Associations ===============================================================

  belongs_to :tool

  # Callbacks ==================================================================
  
  validates :url, presence: true
  
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
  
end
