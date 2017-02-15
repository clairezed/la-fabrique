class Admin < ActiveRecord::Base
  # Configurations =============================================================
  
  # Include default devise modules. Others available are: 
  #   :registerable, :recoverable, :rememberable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable
  
  # Associations ===============================================================

  # Callbacks ==================================================================

  # Scopes =====================================================================
  
  # Class Methods ==============================================================

  # Instance Methods ===========================================================

  private #=====================================================================
end
