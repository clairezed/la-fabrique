# frozen_string_literal: true

module AxisHelper
  def axis_options(axes = Axis.all)
    axes.order(position: :asc).map do |axis|
      [axis.title, axis.id]
    end
  end
end
