# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_theme_key
  # before_action :http_authentication
  before_action :set_default_seos!, :get_basic_pages
  after_action :flash_to_headers, if: -> { request.xhr? && flash.present? }
  after_action :check_visited

  protected

  def get_seo_for_static_page(param)
    seo = Seo.where(param: param).first
    if seo
      @seo_title       = seo.title if seo.title.present?
      @seo_description = seo.description if seo.description.present?
      @seo_keywords    = seo.keywords if seo.keywords.present?
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_path unless request.xhr?
  end

  private

  def set_default_seos!
    @seo_title       ||= 'La fabrique du monde'
    @seo_description ||= 'La Fabrique du Monde est un espace de co-construction dédié à la mobilité, celle-ci étant entendue comme la rencontre de personnes porteuses d’une histoire singulière et désireuses d’en bâtir une commune.'
    @seo_keywords    ||= 'fabrique, monde, mobilité, outils'
  end

  # Pour les requêtes ajax
  def flash_to_headers
    %i(error alert warning notice).each do |type|
      next if flash[type].blank?
      content = { message: flash[type], type: ApplicationHelper::FLASH_BS_TYPES[type] }
      response.headers['X-Message'] = content.to_json
      flash.discard
      break
    end
  end

  def get_basic_pages
    @basic_pages = BasicPage.where(enabled: true).order(position: :asc)
  end

  def http_authentication
    if Rails.env.staging? || Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'mirador' && password == 'mirador2017'
      end
    end
  end

  def check_visited
    cookies['mt_visited'] = { value: true, expires: 13.month.from_now }
  end

  # Theme management ================================================

  def current_theme
    @current_theme ||= (Theme.where(id_key: @theme_key).first || Theme.default)
  end
  helper_method :current_theme

  def get_theme_key
    host = request.host
    @theme_key = Rails.configuration.theme_hosts[host]
    @theme_key = 'mobility' if @theme_key.blank?
  end


  # Back path =======================================================

  def set_back_path(session_name = :back_path)
    return if request.env['HTTP_REFERER'].blank?
    referer = URI.parse(request.env['HTTP_REFERER']) rescue nil
    return if referer.blank?
    session[session_name] = URI(request.referer).to_s
  end

  def back_path(session_name = :back_path)
    session[session_name]
  end
  helper_method :back_path

end
