class AxesController < ApplicationController
  include SlugsAndRedirections

  def index
    @axes = current_theme.axes.enabled.includes(:tools)
  end

end