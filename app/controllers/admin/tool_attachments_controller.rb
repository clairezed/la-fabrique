# class Admin::ToolAttachmentsController < Admin::BaseController
#   respond_to :json

#   before_action :find_attachement, only: [ :edit, :update, :destroy ]


#   def index
#     @attachments = Asset::ToolAttachment.all
#     render json: @attachment, eachSerializer: ToolAttachmentSerializer 
#   end

#   def create
#     p attachment_params
#     if params[:asset_tool_attachment][:assetable_id].present?
#       @tool = Tool.find(params[:asset_tool_attachment][:assetable_id])
#       @attachment = @tool.attachments.new(attachment_params) 
#     else
#       @attachment = Asset::ToolAttachment.new(attachment_params)
#     end
#     p @attachment
#     if @attachment.save
#       render json: @attachment, serializer: ToolAttachmentSerializer 
#     else
#       render status: 304, json: {errors: @attachment.errors.full_messages}
#     end
#   end

#   def edit
#     @tool = @attachment.assetable
#     render layout: !request.xhr?
#   end

#   def update
#     if @attachment.update(attachment_params)
#       render json: @attachment, serializer: ToolAttachmentSerializer 
#     else
#       render status: 304, json: {errors: @attachment.errors.full_messages}
#     end
#   end


#   def destroy
#     if @attachment.destroy
#       render json: {id: params[:id]}
#     else
#       render status: :unprocessable_entity, json: {errors: @attachment.errors.full_messages}
#     end
#   end

#   private # ----------------------------------------
  
#   def attachment_params
#     # params.require(:attachment_asset)
#     params
#       .fetch(:asset_tool_attachment){ {}.with_indifferent_access } # peut être vide
#       .permit :id,
#               :asset,
#               :title,
#               :custom_file_name,
#               :format_type,
#               :assetable_id
#   end

#   def find_attachement
#     @attachment = Asset::ToolAttachment.find(params[:id])
#   end

# end
