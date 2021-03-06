# frozen_string_literal: true

module ToolFormatTypeHelper
  # Format -----------------------------------------------

  def tool_format_type_title(format = nil)
    return '' if format.blank?
    I18n.t(format, scope: %i(tool_format_types title))
  end

  def tool_format_type_icon(format = nil)
    return '' if format.blank?
    I18n.t(format, scope: %i(tool_format_types icon))
  end

  def tool_format_type_options(formats = Asset::ToolAttachment.format_types.keys)
    formats.map do |format|
      [tool_format_type_title(format), format.to_s]
    end
  end
end
