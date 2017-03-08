class ToolsController < ApplicationController
  include SlugsAndRedirections

  def index
    params[:sort] ||= "sort_by_created_at asc"
    @tools = Tool.enabled.apply_filters(params)
    respond_to do |format|
      format.html do
        @tools = @tools.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        render json: @tools.map { |tool| { title: tool.title, show_url: tool_path(tool) }}
      end
    end
  end

  def show
    @tool = get_object_from_param_or_redirect(Tool.enabled)
    @comment = @tool.comments.new
  end


end