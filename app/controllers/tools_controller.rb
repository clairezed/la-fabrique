class ToolsController < ApplicationController
  include SlugsAndRedirections

    before_action :find_tool, except: [ :index, :new, :create ]


  def index
    params[:sort] ||= "sort_by_created_at asc"
    @tools = Tool.enabled.apply_filters(params)
    respond_to do |format|
      format.html do
        @tools = @tools.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        render json: @tools.map { |tool| { title: tool.title, show_url: tool_path(tool) }}
      end
    end
  end

  def show
    @comment = @tool.comments.new
  end

  # Tool proposition ========================================

  def new
    @tool = Tool.new
  end

  def create
    @tool = ToolSetter.new(Tool.new, part_1_params).call
    if @tool.save
      flash[:notice] = "Les informations ont bien été enregistrées"
      redirect_to edit_part_2_tool_path(@tool)
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'outil"
      build_tool_relations
      render :new
    end
  end

  def edit_part_1
  end

  def part_1
    @tool = ToolSetter.new(@tool, part_1_params).call
    if @tool.save
      flash[:notice] = "Les informations ont bien été enregistrées"
      redirect_to params[:continue].present? ? edit_part_1_path(@tool) : edit_part_2_tool_path(@tool)
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
    @tool = ToolSetter.new(@tool, part_2_params).call
    if @tool.save
      if params[:continue].present?
        flash[:notice] = "Les informations ont bien été enregistrées"
        redirect_to edit_part_2_tool_path(@tool)
      else
        @tool.submit! if @tool.may_submit?
        redirect_to submission_success_tool_path(@tool)
      end
    else
      build_tool_relations
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'outil'"
      render :edit_part_2
    end
  end

  def submission_success
  end

  private # ==================================================

  def find_tool
    @tool = Tool.from_param params[:id]
    # @tool = get_object_from_param_or_redirect(Tool.enabled)
  end

  def build_tool_relations
    3.times { @tool.steps.build() } if @tool.steps.empty?
    @attachment = @tool.attachments.build
    # @tool.build_seo unless @tool.seo.present?
  end

  # strong parameters
  def part_1_params
    params.require(:tool).permit(
      :axis_id, :tool_category_id, :title,
      :group_size, :duration, :level, :public, tag_ids: [])
  end

  # strong parameters
  def part_2_params
    params.require(:tool).permit(
      :description, :teaser, 
      :public, :licence, :goal, :material, 
      :source, :advice, :submitter_email, :description_type,
      steps_attributes: [:id, :description, :_destroy],
      seo_attributes: [:slug, :title, :keywords, :description, :id])
  end

  def get_current_part(params_part)
    p
  end

end