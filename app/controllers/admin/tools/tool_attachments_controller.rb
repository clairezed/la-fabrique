# frozen_string_literal: true

class Admin::Tools::ToolAttachmentsController < Admin::Tools::BaseController
  respond_to :json

  before_action :find_attachement, only: %i(edit update destroy)

  def index
    @attachments = @tool.attachments.order(position: :asc)
    render json: @attachments, eachSerializer: ToolAttachmentSerializer
  end

  def create
    @attachment = @tool.attachments.new(attachment_params)
    if @attachment.save
      render json: @attachment, serializer: ToolAttachmentSerializer
    else
      render status: 304, json: { errors: @attachment.errors.full_messages }
    end
  end

  def edit
    render layout: false
  end

  def update
    if @attachment.update(attachment_params)
      render json: @attachment, serializer: ToolAttachmentSerializer
    else
      render status: 304, json: { errors: @attachment.errors.full_messages }
    end
  end

  def destroy
    if @attachment.destroy
      render json: { id: params[:id] }
    else
      render status: :unprocessable_entity, json: { errors: @attachment.errors.full_messages }
    end
  end

  private # ----------------------------------------

  def attachment_params
    # params.require(:attachment_asset)
    params
      .fetch(:asset_tool_attachment) { {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title,
              :custom_file_name,
              :format_type,
              :assetable_id
  end

  def find_attachement
    @attachment = Asset::ToolAttachment.find(params[:id])
  end
end
