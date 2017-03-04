class Admin::ToolsController < Admin::BaseController

  before_action :find_tool, except: [ :index, :new, :create ]

  def index
    params[:sort] ||= "sort_by_created_at asc"
    @tools = Tool.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @tool = Tool.new
    @attachment = Asset::ToolAttachment.new
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
    @attachment = Asset::ToolAttachment.new
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

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Pdf::Tool.new(@tool)
        send_data pdf.to_pdf, filename: pdf.filename, type: 'application/pdf'
      end
    end
  end

  def accept
    flash[:notice] = "Fiche validée avec succès"
    begin
      @tool.accept!
    rescue AASM::InvalidTransition
      # admin click too fast and send 2 times the request. We ignore the second and send the same flash message than a success
    end
    redirect_to(current_search_path)
  end

  def reject
    flash[:notice] = "Fiche refusée avec succès"
    begin
      @tool.reject!
    rescue AASM::InvalidTransition
      # admin click too fast and send 2 times the request. We ignore the second and send the same flash message than a success
    end
    redirect_to(current_search_path)
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


  private # ==================================================

  def find_tool
    @tool = Tool.from_param params[:id]
  end

  # strong parameters
  def tool_params
    params.require(:tool).permit(
      :axis_id, :tool_category_id, :title, :description, :teaser, :enabled, 
      :group_size, :duration, :level, :public, :licence, :goal, :material, 
      :source, :source_url, :submitter_email, tag_ids: [],
      seo_attributes: [:slug, :title, :keywords, :description, :id])
  end

  def current_search_path
    url_for(search_params.merge(action: :index))
  end

  def search_params
    params.permit(:sort, :page, :by_title, :by_axis, :by_tool_category, :by_state, 
      :by_duration, :by_group_size)
  end
  helper_method :search_params
  
end
