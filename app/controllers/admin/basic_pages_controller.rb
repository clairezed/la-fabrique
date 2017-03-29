# frozen_string_literal: true

class Admin::BasicPagesController < Admin::BaseController
  before_action :find_basic_page, only: %i(edit update position destroy)

  def index
    params[:sort] ||= 'sort_by_position asc'
    @basic_pages = BasicPage.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @basic_page = BasicPage.new
    @basic_page.build_seo
  end

  def create
    @basic_page = BasicPage.new(basic_page_params)
    if @basic_page.save
      flash[:notice] = 'La page a été créée avec succès'
      redirect_to params[:continue].present? ? edit_admin_basic_page_path(@basic_page) : admin_basic_pages_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la page"
      render :new
    end
  end

  def edit; end

  def update
    if @basic_page.update_attributes(basic_page_params)
      flash[:notice] = 'La page a été mise à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_basic_page_path(@basic_page) : admin_basic_pages_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la page"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @basic_page.insert_at params[:position].to_i
      flash[:notice] = 'Les pages ont été réordonnées avec succès'
    end
    redirect_to admin_basic_pages_path
  end

  def destroy
    @basic_page.destroy
    flash[:notice] = 'La page a été supprimée avec succès'
    redirect_to admin_basic_pages_path
  end

  private

  def find_basic_page
    @basic_page = BasicPage.from_param params[:id]
  end

  # strong parameters
  def basic_page_params
    params.require(:basic_page).permit(:title, :content, :enabled, seo_attributes: %i(slug title keywords description id))
  end
end
