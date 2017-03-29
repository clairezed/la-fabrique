# frozen_string_literal: true

class Admin::SeosController < Admin::BaseController
  before_action :find_seo, only: %i(edit update)

  def index
    @seos = Seo.where.not(param: nil)
  end

  def edit; end

  def update
    if @seo.update_attributes(seo_params)
      flash[:notice] = 'Les SEO ont été mis à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_seo_path(@seo) : admin_seos_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour des SEO"
      render :edit
    end
  end

  private

  def find_seo
    @seo = Seo.where.not(param: nil).find params[:id]
  end

  # strong parameters
  def seo_params
    params.require(:seo).permit(:title, :keywords, :description)
  end
end
