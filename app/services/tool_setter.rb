# frozen_string_literal: true

class ToolSetter
  def initialize(tool, params = {})
    @tool = tool
    @params = params
  end

  def set_part_1
    manage_tags
    manage_uncheckable_enums
    @tool.attributes = @params
    @tool
  end

  def set_part_2
    @tool.attributes = @params
    @tool
  end

  private # ===================================================

  def manage_tags
    return if @params['tag_ids'].blank?
    # grab eventual new tags (everything that is neither blank nor an id in params[:tag_ids])
    new_tag_titles = @params['tag_ids']
                     .reject!(&:blank?)
                     .reject { |t| Tag.where(id: t.to_i).any? }

    new_tag_ids = new_tag_titles.inject([]) do |array, tag_title|
      t = Tag.where(title: tag_title).first_or_create
      array.push(t.id)
    end

    # replace tag_titles with newly created tags ids
    @params['tag_ids'] = @params['tag_ids'] - new_tag_titles + new_tag_ids
  end

  # certains enums peuvent finalement être blank
  def manage_uncheckable_enums
    ['group_size', 'duration', 'level'].each do |enum|
      @params[enum] = nil unless @params[enum].present?
    end
  end

end
