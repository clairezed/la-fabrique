class ToolsController < ApplicationController
  include SlugsAndRedirections

  def index
    params[:sort] ||= "sort_by_created_at asc"
    @tools = Tool.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def show 
    @tool = get_object_from_param_or_redirect(Tool.enabled)
  end


end