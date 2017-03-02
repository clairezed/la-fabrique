class Admin::ToolAttachmentsController < Admin::BaseController
  respond_to :json

  def index
    @attachments = Asset::ToolAttachment.all
    render :json => @attachments.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    p attachment_params
    if params[:asset_tool_attachment][:assetable_id].present?
      @tool = Tool.find(params[:asset_tool_attachment][:assetable_id])
      @attachment = @tool.attachments.new(attachment_params) 
    else
      @attachment = Asset::ToolAttachment.new(attachment_params)
    end
    p @attachment
    if @attachment.save
      p "SAVED"
      p @attachment.to_jq_upload
      respond_to do |format|
        format.html {  
          render :json => [@attachment.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => { :files => [@attachment.to_jq_upload] }
        }
      end
    else
      render status: 304, json: {errors: @attachment.errors.full_messages}
    end
  end

  def update
    @attachment = @event.attachments.find(params[:id])
    if !@attachment.update(attachment_params)
      @errors = @event.errors.full_messages
    end
  end


  def destroy
    @attachment = Asset::ToolAttachment.find(params[:id])
    if @attachment.destroy
      render json: {id: params[:id]}
    else
      render status: :unprocessable_entity, json: {errors: @attachment.errors.full_messages}
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
