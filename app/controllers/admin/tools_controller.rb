# frozen_string_literal: true

class Admin::ToolsController < Admin::BaseController
  before_action :find_tool, except: %i(index new create)

  def index
    params[:sort] ||= 'sort_by_created_at desc'
    @tools = Tool.apply_filters(params)
                 .includes(:axis)
                 .includes(:seo)
                 .includes(:tool_category)
    respond_to do |format|
      format.html do
        @tools = @tools.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        render json: @tools.enabled
      end
    end
  end

  # Tool form ========================================

  def new
    @tool = Tool.new
    build_tool_relations
  end

  def create
    @tool = ToolSetter.new(Tool.new, part_1_params).set_part_1
    if @tool.save
      flash[:notice] = 'La fiche outil a été créé avec succès'
      redirect_to params[:continue].present? ? edit_part_2_admin_tool_path(@tool) : edit_part_1_admin_tool_path(@tool)
    else
      flash[:error] = "Une erreur s'est produite lors de la création de la fiche"
      build_tool_relations
      render :new
    end
  end

  def edit_part_1; end

  def part_1
    @tool = ToolSetter.new(@tool, part_1_params).set_part_1
    if @tool.save
      flash[:notice] = 'Les informations ont bien été enregistrées'
      redirect_to params[:continue].present? ? edit_part_2_admin_tool_path(@tool) : edit_part_1_admin_tool_path(@tool)
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'outil"
      build_tool_relations
      render :edit_part_1
    end
  end

  def edit_part_2
    build_tool_relations
  end

  def part_2
    @tool = ToolSetter.new(@tool, part_2_params).set_part_2
    if @tool.save
      # @tool.accept! if @tool.may_accept?
      flash[:notice] = 'Les informations ont bien été enregistrées'
      redirect_to params[:continue].present? ? admin_tools_path : edit_part_2_admin_tool_path(@tool)
    else
      build_tool_relations
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'outil'"
      render :edit_part_2
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
    flash[:notice] = 'Outil validé avec succès'
    begin
      @tool.accept!
    rescue AASM::InvalidTransition
      # admin click too fast and send 2 times the request. We ignore the second and send the same flash message than a success
    end
    redirect_to(current_search_path)
  end

  def reject
    flash[:notice] = 'Outil refusé avec succès'
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
      flash[:notice] = 'Les outils ont été réordonnées avec succès'
    end
    redirect_to admin_tools_path
  end

  def destroy
    @tool.destroy
    flash[:notice] = "L'outil a été supprimé avec succès"
    redirect_to admin_tools_path
  end

  private # ==================================================

  def find_tool
    @tool = Tool.from_param params[:id]
  end

  def build_tool_relations
    3.times { @tool.steps.build } if @tool.steps.empty?
    @attachment = @tool.attachments.build
    @tool.build_seo if @tool.seo.blank?
  end

  # strong parameters
  def part_1_params
    params.require(:tool).permit(
      :axis_id, :tool_category_id, :title,  :current_step,
      :group_size, :duration, :level, :public, tag_ids: []
    )
  end

  def part_2_params
    params.require(:tool).permit(
      :description, :teaser, :description_type,
      :public, :licence, :goal, :material, :source, :advice, :hide_contact,
      :submitter_email, :submitter_organization, :submitter_firstname, :submitter_lastname,
      steps_attributes: %i(id description _destroy),
      seo_attributes: %i(slug title keywords description id)
    )
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
