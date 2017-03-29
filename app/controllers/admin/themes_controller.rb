# frozen_string_literal: true

class Admin::ThemesController < Admin::BaseController
  before_action :find_theme, only: %i(edit update position destroy)

  def index
    params[:sort] ||= 'sort_by_position asc'
    @themes = Theme.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @theme = Theme.new
    @theme.build_seo
  end

  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      flash[:notice] = 'La thématique a été créée avec succès'
      redirect_to params[:continue].present? ? edit_admin_theme_path(@theme) : admin_themes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la thématique"
      render :new
    end
  end

  def edit; end

  def update
    if @theme.update_attributes(theme_params)
      flash[:notice] = 'La thématique a été mise à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_theme_path(@theme) : admin_themes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la thématique"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @theme.insert_at params[:position].to_i
      flash[:notice] = 'Les thématiques ont été réordonnées avec succès'
    end
    redirect_to admin_themes_path
  end

  def destroy
    begin
      flash[:notice] = 'La thématique a été supprimée avec succès' if @theme.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = 'Cette thématique ne peut être supprimée car des éléments lui sont dépendants'
    end
    redirect_to admin_themes_path
  end

  private

  def find_theme
    @theme = Theme.from_param params[:id]
  end

  # strong parameters
  def theme_params
    params.require(:theme).permit(:title, :enabled, seo_attributes: %i(slug title keywords description id))
  end
end
