# frozen_string_literal: true

class Tools::LinksController < Tools::BaseController
  respond_to :json

  before_action :find_link, only: %i(edit update destroy)

  def index
    @links = @tool.links.apply_filters(params)
    render json: @links, eachSerializer: LinkSerializer
  end

  def new
    @link = @tool.links.new
    render layout: false
  end

  def create
    @link = @tool.links.new(link_params)
    if @link.save
      render json: @link, serializer: LinkSerializer
    else
      render :new, layout: false, status: 422
    end
  end

  def edit
    # @tool = @link.tool
    render layout: !request.xhr?
  end

  def update
    if @link.update(link_params)
      render json: @link, serializer: LinkSerializer
    else
      render :edit, layout: false, status: 422

    end
  end

  def destroy
    if @link.destroy
      render json: { id: params[:id] }
    else
      render status: :unprocessable_entity, json: { errors: @link.errors.full_messages }
    end
  end

  private # ----------------------------------------

  def link_params
    # params.require(:link_asset)
    params
      .fetch(:link) { {}.with_indifferent_access } # peut être vide
      .permit :id,
              :url,
              :title,
              :format_type,
              :tool_id
  end

  def find_link
    @link = Link.find(params[:id])
  end
end
