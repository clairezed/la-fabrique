class LinkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ToolFormatTypeHelper

  attributes  :id, 
              :title,
              :url,
              :delete_url,
              :admin_delete_url,
              :edit_url,
              :admin_edit_url,
              :format_icon,
              :format_title,
              :tool_id

  #TODO
  def edit_url
    edit_tool_link_path(object.tool.id, object.id)
  end

  def admin_edit_url
    edit_admin_link_path(object.id)
  end

  #TODO
  def delete_url
    tool_link_path(object.tool.id, object.id)
  end

  def admin_delete_url
    admin_link_path(object.id)
  end

  def format_icon
    tool_format_type_icon(object.format_type)
  end

  def format_title
    tool_format_type_title(object.format_type)
  end


end