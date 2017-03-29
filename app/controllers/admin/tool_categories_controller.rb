# frozen_string_literal: true

class Admin::ToolCategoriesController < Admin::BaseController
  before_action :find_tool_category, only: %i(edit update position destroy)

  def index
    params[:sort] ||= 'sort_by_position asc'
    @tool_categories = ToolCategory.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @tool_category = ToolCategory.new
    @tool_category.build_seo
  end

  def create
    @tool_category = ToolCategory.new(tool_category_params)
    if @tool_category.save
      flash[:notice] = 'La catégorie a été créée avec succès'
      redirect_to params[:continue].present? ? edit_admin_tool_category_path(@tool_category) : admin_tool_categories_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la catégorie"
      render :new
    end
  end

  def edit; end

  def update
    if @tool_category.update_attributes(tool_category_params)
      flash[:notice] = 'La catégorie a été mise à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_tool_category_path(@tool_category) : admin_tool_categories_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la catégorie"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @tool_category.insert_at params[:position].to_i
      flash[:notice] = 'Les catégories ont été réordonnées avec succès'
    end
    redirect_to admin_tool_categories_path
  end

  def destroy
    begin
      flash[:notice] = 'La catégorie a été supprimée avec succès' if @tool_category.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = 'Cette catégorie ne peut être supprimée car des éléments lui sont dépendants'
    end
    redirect_to admin_tool_categories_path
  end

  # def destroy
  #   @tool_category.destroy
  #   flash[:notice] = "La catégorie a été supprimée avec succès"
  #   redirect_to admin_tool_categories_path
  # end

  private

  def find_tool_category
    @tool_category = ToolCategory.from_param params[:id]
  end

  # strong parameters
  def tool_category_params
    params.require(:tool_category).permit(:title, :description, :enabled, seo_attributes: %i(slug title keywords description id))
  end
end
