class Admin::Tools::AttachmentsController < Admin::Tools::BaseController

  respond_to :js

  def create
    @document = @event.attachments.new(document_params)
    if !@event.save
      @errors = @event.errors.full_messages
    end
  end

  def update
    @document = @event.attachments.find(params[:id])
    if !@document.update(document_params)
      @errors = @event.errors.full_messages
    end
  end


  def destroy
    @document = @event.attachments.find(params[:id])
    if !@document.destroy
      @errors = @document.errors.full_messages
    end
  end

  private

  def find_event
    @event = Event.from_param(params.require :event_id)
  end

  def poster_params
    params.require(:event_poster)
  end

   def document_params
    params
      .fetch(:document){ {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title
  end

end
