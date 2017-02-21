class Admin::ToolsController < Admin::BaseController

  before_action :find_tool, only: [ :edit, :update, :position, :destroy ]

  def index
    params[:sort] ||= "sort_by_created_at asc"
    @tools = Tool.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @tool = Tool.new
    @tool.build_seo
  end
  
  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      flash[:notice] = "La fiche a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_tool_path(@tool) : admin_tools_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la fiche"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @tool.update_attributes(tool_params)
      flash[:notice] = "La fiche a été mise à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_tool_path(@tool) : admin_tools_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la fiche"
      render :edit
    end
  end
  
  def position
    if params[:position].present?
      @tool.insert_at params[:position].to_i 
      flash[:notice] = "Les fiches ont été réordonnées avec succès"
    end
    redirect_to admin_tools_path
  end

  def destroy
    @tool.destroy
    flash[:notice] = "L'axe a été supprimé avec succès"
    redirect_to admin_tools_path
  end


  private

  def find_tool
    @tool = Tool.from_param params[:id]
  end

  # strong parameters
  def tool_params
    params.require(:tool).permit(
      :axis_id, :tool_category_id, :title, :description, :teaser, :enabled, 
      :group_size, :duration, :level, :public, :licence, :goal, :material, :source, :source_url, :submitter_email,
      seo_attributes: [:slug, :title, :keywords, :description, :id])
  end
  
end
