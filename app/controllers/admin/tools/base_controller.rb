class Admin::Tools::BaseController < Admin::BaseController

  before_action :load_tool

  private

  def load_tool
    @tool = Tool.from_param(params[:tool_id])
  end


end