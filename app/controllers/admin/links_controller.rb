# frozen_string_literal: true
# class Admin::LinksController < Admin::BaseController

#   respond_to :json

#   before_action :find_tool, only: [ :new ]
#   before_action :find_link, only: [ :edit, :update, :destroy ]

#   def index
#     @links = Link.apply_filters(params)
#     render json: @links, eachSerializer: LinkSerializer
#   end

#   def new
#     @link = Link.new
#     render layout: false
#   end

#   def create
#     if params[:link][:tool_id].present?
#       @tool = Tool.find(params[:link][:tool_id])
#       @link = @tool.links.new(link_params)
#     else
#       @link = Link.new(link_params)
#     end
#     if @link.save
#       render json: @link, serializer: LinkSerializer
#     else
#       render :new, layout: false, status: 422
#     end
#   end

#   def edit
#     @tool = @link.tool
#     render layout: !request.xhr?
#   end

#   def update
#     if @link.update(link_params)
#       render json: @link, serializer: LinkSerializer
#     else
#       render :edit, layout: false, status: 422

#     end
#   end

#   def destroy
#     if @link.destroy
#       render json: {id: params[:id]}
#     else
#       render status: :unprocessable_entity, json: {errors: @link.errors.full_messages}
#     end
#   end

#   private # ----------------------------------------

#   def link_params
#     # params.require(:link_asset)
#     params
#       .fetch(:link){ {}.with_indifferent_access } # peut être vide
#       .permit :id,
#               :url,
#               :title,
#               :format_type,
#               :tool_id
#   end

#   def find_tool
#     @tool = params[:tool_id].present? ? Tool.find(params[:tool_id]) : Tool.new
#   end

#   def find_link
#     @link = Link.find(params[:id])
#   end

# end
