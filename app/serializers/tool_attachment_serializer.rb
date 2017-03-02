class ToolAttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ToolAttachmentHelper

  attributes  :id, 
              :name,
              :size, 
              :displayable,
              :url,
              :thumbnail_url,
              :delete_url,
              :admin_delete_url,
              :format_icon,
              :format_title

  def name
    object.custom_file_name
  end

  def size
    object.asset_file_size
  end

  def displayable
    object.displayable?
  end

  def url
    object.asset.url
  end

  def thumbnail_url
    object.asset.url(:preview)
  end

  #TODO
  def delete_url
    admin_tool_attachment_path(object.id)
  end

  def admin_delete_url
    admin_tool_attachment_path(object.id)
  end

  def format_icon
    tool_attachment_format_type_icon(object.format_type)
  end

  def format_title
    tool_attachment_format_type_title(object.format_type)
  end


end