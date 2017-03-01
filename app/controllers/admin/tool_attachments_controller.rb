class Admin::ToolAttachmentsController < Admin::BaseController

  respond_to :js

  def create
    p attachment_params
    if params[:asset_tool_attachment][:assetable_id].present?
      @tool = Tool.find(params[:asset_tool_attachment][:assetable_id])
      @attachment = @tool.attachments.new(attachment_params) 
    else
      @attachment = Asset::ToolAttachment.new(attachment_params)
    end
    p @attachment
    if !@attachment.save
      render status: status, json: {errors: @attachment.errors.full_messages}
    end
  end

  def update
    @attachment = @event.attachments.find(params[:id])
    if !@attachment.update(attachment_params)
      @errors = @event.errors.full_messages
    end
  end


  def destroy
    @attachment = @event.attachments.find(params[:id])
    if !@attachment.destroy
      @errors = @attachment.errors.full_messages
    end
  end

  private
  
  def attachment_params
    # params.require(:attachment_asset)
    params
      .fetch(:asset_tool_attachment){ {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title,
              :custom_file_name,
              :format_type
  end

end
