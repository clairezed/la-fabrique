# frozen_string_literal: true

class StaticsController < ApplicationController
  def show
    render action: params[:filename]
  rescue ActionView::MissingTemplate
    redirect_to '/404'
  end
end
