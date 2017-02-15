module SlugsAndRedirections
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      flash[:error] = "Element non trouvé"
      redirect_to root_path if !request.xhr?
    end
  end

  def get_object_from_param_or_redirect(collection, action = "show")
    object = collection.from_param params[:id]
    if object.to_param != params[:id]
      redirect_to( action: action, id: object.to_param, status: 301 ) and return
    end
    @seo_title       = object.seo_title if !object.seo_title.blank?
    @seo_description = object.seo_description if !object.seo_description.blank?
    @seo_keywords    = object.seo_keywords if !object.seo_keywords.blank?
    object
  end

end