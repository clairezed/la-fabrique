class AxesController < ApplicationController
  include SlugsAndRedirections

  def index
    @axes = Theme.default.axes.enabled
  end

end