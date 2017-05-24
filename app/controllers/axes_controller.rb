# frozen_string_literal: true

class AxesController < ApplicationController
  include SlugsAndRedirections

  def index
    @axes = current_theme.axes.enabled.order(position: :asc)
  end
end
