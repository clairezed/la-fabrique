# frozen_string_literal: true

class Admin::TrainingsController < Admin::BaseController
  before_action :find_training, only: %i(edit update position destroy)

  def index
    params[:sort] ||= 'sort_by_position asc'
    @trainings = Training.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @training = Training.new
    @training.build_seo
  end

  def create
    @training = Training.new(training_params)
    if @training.save
      flash[:notice] = 'Le parcours a été créé avec succès'
      redirect_to params[:continue].present? ? edit_admin_training_path(@training) : admin_trainings_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du parcours"
      render :new
    end
  end

  def edit; end

  def update
    if @training.update_attributes(training_params)
      flash[:notice] = 'Le parcours a été mis à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_training_path(@training) : admin_trainings_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du parcours"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @training.insert_at params[:position].to_i
      flash[:notice] = 'Les parcours ont été réordonnés avec succès'
    end
    redirect_to admin_trainings_path
  end

  def destroy
    @training.destroy
    flash[:notice] = 'Le parcours a été supprimé avec succès'
    redirect_to admin_trainings_path
  end

  private

  def find_training
    @training = Training.from_param params[:id]
  end

  # strong parameters
  def training_params
    params.require(:training).permit(:title, :enabled, :tool_ids, tool_ids: [], seo_attributes: %i(slug title keywords description id))
  end
end
