# frozen_string_literal: true

class ToolHistorySerializer < ActiveModel::Serializer
  include ToolHelper

  attributes  :id,
              :created_at,
              :updated_at,
              :submitted_at,
              :state,
              :axis,
              :category,
              :title,
              :teaser,
              :description,
              :group_size,
              :duration,
              :level,
              :goal,
              :material,
              :source,
              :licence,
              :public,
              :advice,
              :tags,
              :submitter_email,
              :submitter_firstname,
              :submitter_lastname,
              :submitter_organization

  def axis
    object.axis.title
  end

  def category
    object.tool_category.title
  end

  def description
    if object.steps?
      steps
    else
      simple_description
    end
  end

  def group_size
    tool_group_size(object.group_size)
  end

  def level
    tool_level(object.level)
  end

  def duration
    tool_duration(object.duration)
  end

  def tags
    object.tags.map(&:title).join(", ")
  end

  private

  def simple_description
    object.description
  end

  def steps
    object.steps.map{ |s| { s.position => s.description } }
  end



end
