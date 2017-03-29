# frozen_string_literal: true

class Tools::BaseController < ApplicationController
  before_action :load_tool

  private

  def load_tool
    @tool = Tool.from_param(params[:tool_id])
  end
end
