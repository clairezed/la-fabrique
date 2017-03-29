class Step < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  
  acts_as_list
    
  # Associations ===============================================================

  belongs_to :tool

  # Callbacks ==================================================================
  validates :description, presence: true
  
  # Scopes =====================================================================
  
  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self

    # klass = klass.by_title(params[:by_title]) if params[:by_title].present?

    klass.apply_sorts(params)
  end
  
  # Instance Methods ===========================================================

  # private #=====================================================================
  
end
