class Asset < ActiveRecord::Base

  # Configs ====================================================================

  Paperclip.interpolates :assetable_id do |attachment, _style|
    attachment.instance.assetable_id
  end

  Paperclip.interpolates :custom_file_name do |attachment, _style|
    attachment.instance.custom_file_name
  end

  # Associations ===============================================================
  
  belongs_to :assetable, polymorphic: true, optional: true

  # Validations ================================================================
  
  validates :custom_file_name, presence: true


  # Callbacks ================================================================

  before_validation :set_custom_file_name

  # Instance Methods ===========================================================

  protected #=================================================

  # Définition du nom du fichier customiser (utile surtout pour les images)
  #   Si un custom_file_name est donné, on le parameterize 
  #   Sinon on utilise le nom du fichier uploadé
  def set_custom_file_name
    self.custom_file_name = self.custom_file_name.try(:parameterize)
    self.custom_file_name = self.asset_file_name.split(".").first if self.custom_file_name.blank?
  end
  
end
