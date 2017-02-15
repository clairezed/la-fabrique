class Admin::BaseController < ApplicationController

  before_action :authenticate_admin!
  layout 'administration'

  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Element non trouvé"
    redirect_to admin_root_path if !request.xhr?
  end
  
end