class Asset::ToolAttachment < Asset

  # Configs ====================================================================

  DOCUMENT_MIME_TYPES = [Mime[:pdf]].freeze

  IMAGE_MIME_TYPES= %i[
    png
    jpeg
    gif
  ].map{|type| Mime[type] }.compact.freeze

  VALID_CONTENT_TYPES = [*DOCUMENT_MIME_TYPES, *IMAGE_MIME_TYPES].freeze

  acts_as_list

  #====== Si stockage dédié ========
  has_attached_file :asset,
    styles: {
        thumb: "100x100#",
        preview: "300x300>"
    },
    # url: "/uploads/tool_attachments/:id/:style/:asset_file_name.:extension",
    url: "/uploads/tool_attachments/:id/:style.:extension",
    path: ":rails_root/public/uploads/tool_attachments/:id/:style.:extension"
  
    #====== Si stockage S3 ========
    # === créer un config/s3.yml et ajouter la gem 'aws/sdk'
    # has_attached_file :asset,
    #   styles: {thumb: "100x100>"},
    #   storage: :s3,
    #   s3_credentials: "#{Rails.root}/config/s3.yml",
    #   path: "/project/posts/:assetable_id/pictures/:id/:style.:extension"


  enum format_type: {
    picture:  0, # 
    document: 1, # 
    slide:    2, # 
    sound:    3, # 
    video:    4
  }

  # Validations ================================================================

  validates_attachment :asset, presence: true,
                       content_type: { content_type: VALID_CONTENT_TYPES },
                       size: { less_than: Rails.application.config.max_upload_size }

  # Callbacks ==================================================================

  # si l'asset n'est pas une image, renvoie false et stoppe le post processing
  #
  before_post_process :displayable?

  # Instance methods ===========================================================

  def displayable?
    IMAGE_MIME_TYPES.include? asset_content_type
  end

  def to_s
    self.asset_file_name
  end

end
