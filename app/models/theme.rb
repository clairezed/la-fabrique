class Theme < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include Seoable
  
  acts_as_list
  
  # Associations ===============================================================

  has_many :axes, dependent: :restrict_with_exception
  has_many :tools, through: :axes

  # Callbacks ==================================================================
  validates :title, presence: true
  
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
    self.where(id_key: "mobility").first || self.first
  end
  
  # Instance Methods ===========================================================

end
