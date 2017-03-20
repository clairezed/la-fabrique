class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :http_authentication
  before_action :set_default_seos!, :get_basic_pages
  after_action :flash_to_headers, if: ->{ request.xhr? && flash.present? }
  after_action :check_visited

  protected
  
  def get_seo_for_static_page(param)
    seo = Seo.where(param: param).first
    if seo
      @seo_title       = seo.title if !seo.title.blank?
      @seo_description = seo.description if !seo.description.blank?
      @seo_keywords    = seo.keywords if !seo.keywords.blank?
    end
  end
  
  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_path if !request.xhr?
  end 
  
  private

  def set_default_seos!
    @seo_title       ||= "Title du projet"
    @seo_description ||= "Description du projet"
    @seo_keywords    ||= "keywords du projet, projet"
  end

  # Pour les requêtes ajax
  def flash_to_headers
    [:error, :alert, :warning, :notice].each do |type|
      if flash[type].present?
        content = { message: flash[type], type: ApplicationHelper::FLASH_BS_TYPES[type] }
        response.headers['X-Message'] = content.to_json
        flash.discard
        break
      end
    end
  end

  def get_basic_pages
    @basic_pages = BasicPage.where(enabled: true).order(position: :asc)
  end

  def http_authentication
    if Rails.env.staging? || Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == "mirador" && password == "mirador2017"
      end
    end
  end

  def check_visited
    cookies.permanent["visited"] = true
  end

  def default_theme
    Theme.where(id_key: "mobility").first || Theme.first
  end

end
