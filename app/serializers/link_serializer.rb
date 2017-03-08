class LinkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ToolAttachmentHelper

  attributes  :id, 
              :name,
              :url,
              :delete_url,
              :admin_delete_url,
              :edit_url,
              :admin_edit_url,
              :format_icon,
              :format_title

  def name
    object.custom_file_name
  end

  #TODO
  def edit_url
    edit_admin_link_path(object.id)
  end

  def admin_edit_url
    edit_admin_link_path(object.id)
  end

  #TODO
  def delete_url
    admin_link_path(object.id)
  end

  def admin_delete_url
    admin_link_path(object.id)
  end

  def format_icon
    tool_attachment_format_type_icon(object.format_type)
  end

  def format_title
    tool_attachment_format_type_title(object.format_type)
  end


end