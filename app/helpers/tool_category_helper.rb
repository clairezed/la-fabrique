module ToolCategoryHelper

  def tool_category_options(tool_categories = ToolCategory.all)
    tool_categories.order(position: :asc).map do |tool_category| 
      [tool_category.title, tool_category.id]
    end
  end

end
