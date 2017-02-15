class BasicPagesController < ApplicationController
  include SlugsAndRedirections

  def show
    @basic_page = get_object_from_param_or_redirect(BasicPage.enabled)
  end


end