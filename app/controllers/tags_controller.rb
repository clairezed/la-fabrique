# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    params[:sort] ||= 'sort_by_created_at asc'
    @tags = Tag.enabled.apply_filters(params)
    respond_to do |format|
      format.html do
        @tags = @tags.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        # title: used by typeahead autocomplete / text : used by select2 in form
        render json: @tags.map { |tag| { title: tag.title, id: tag.id, text: tag.title } }
      end
    end
  end
end
