# frozen_string_literal: true

class ToolsController < ApplicationController
  include SlugsAndRedirections

  before_action :find_tool, except: %i(index new create)

  def index
    params[:sort] ||= 'sort_by_created_at desc'
    @tools = current_theme.tools
                          .enabled
                          .apply_filters(params)
                          .includes(:axis)
                          .includes(:seo)
                          .includes(:tool_category)
                          .includes(:tool_tags)
                          .includes(:tags)
    respond_to do |format|
      format.html do
        @tools = @tools.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        render json: @tools.map { |tool| { title: tool.title, show_url: tool_path(tool) } }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
        @comment = @tool.comments.new
        set_back_path
      format.pdf do
        pdf = Pdf::Tool.new(@tool)
        send_data pdf.to_pdf, filename: pdf.filename, type: 'application/pdf'
      end
    end
  end

  # Tool form ========================================

  def new
    @tool = Tool.new
  end

  def create
    @tool = ToolSetter.new(Tool.new, part_1_params).call
    if @tool.save
      flash[:notice] = 'Les informations ont bien été enregistrées'
      redirect_to edit_part_2_tool_path(@tool)
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'outil"
      build_tool_relations
      render :new
    end
  end

  def edit_part_1; end

  def part_1
    @tool = ToolSetter.new(@tool, part_1_params).call
    if @tool.save
      flash[:notice] = 'Les informations ont bien été enregistrées'
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
        flash[:notice] = 'Les informations ont bien été enregistrées'
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

  def submission_success; end

  private # ==================================================

  def find_tool
    # @tool = Tool.from_param params[:id]
    @tool = get_object_from_param_or_redirect(Tool)
  end

  def build_tool_relations
    3.times { @tool.steps.build } if @tool.steps.empty?
    @attachment = @tool.attachments.build
    # @tool.build_seo unless @tool.seo.present?
  end

  # strong parameters -------------------------------------
  def part_1_params
    params.require(:tool).permit(
      :axis_id, :tool_category_id, :title,
      :group_size, :duration, :level, :public, tag_ids: []
    )
  end

  def part_2_params
    params.require(:tool).permit(
      :description, :teaser, :description_type,
      :public, :licence, :goal, :material, :source, :advice,
      :submitter_email, :submitter_organization, :submitter_firstname, :submitter_lastname,
      steps_attributes: %i(id description _destroy),
      seo_attributes: %i(slug title keywords description id)
    )
  end

end
