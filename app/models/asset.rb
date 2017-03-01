class Asset < ActiveRecord::Base

  # Configs ====================================================================

  Paperclip.interpolates :assetable_id do |attachment, style|
    attachment.instance.assetable_id
  end

  Paperclip.interpolates :custom_file_name do |attachment, style|
    attachment.instance.custom_file_name
  end

  # Associations ===============================================================
  
  belongs_to :assetable, polymorphic: true, optional: true

  # Validations ================================================================
  
  validates :custom_file_name, presence: true


  # Callbacks ================================================================

  before_validation :set_custom_file_name

  after_update :rename_uploded_files, if: :custom_file_name_changed?

  # Instance Methods ===========================================================


  protected #=================================================

  # Définition du nom du fichier customiser (utile surtout pour les images)
  #   Si un custom_file_name est donné, on le parameterize 
  #   Sinon on utilise le nom du fichier uploadé
  def set_custom_file_name
    self.custom_file_name = self.custom_file_name.try(:parameterize)
    self.custom_file_name = self.asset_file_name.split(".").first if self.custom_file_name.blank?
  end

  # Renommage des fichiers sur le serveur en cas de modification du custom_file_name
  # On va renommer le fichier de chaqu'un des style (+ l'original)
  def rename_uploded_files
    if !self.custom_file_name_was.blank?
      self.asset.options[:styles].merge(original: "").each do |key, value|
        new_file_name = File.basename(self.asset.path(key), ".*")
        dir = File.dirname(self.asset.path(key))
        extension = File.extname(self.asset.path(key))
        File.rename("#{dir}/#{self.custom_file_name_was}#{extension}", self.asset.path(key))
      end
    end
  end
end
