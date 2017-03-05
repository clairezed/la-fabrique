class AxesController < ApplicationController
  include SlugsAndRedirections

  def index
    @axes = Theme.default.axes
  end

  def show
    @basic_page = get_object_from_param_or_redirect(BasicPage.enabled)
  end


end