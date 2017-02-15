class StaticsController < ApplicationController

  def show
    render action: params[:filename]
  rescue ActionView::MissingTemplate => e
    redirect_to "/404"
  end

end
