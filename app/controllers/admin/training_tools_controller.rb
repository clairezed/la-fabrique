# frozen_string_literal: true

class Admin::TrainingToolsController < Admin::BaseController
  before_action :find_training_tool, only: %i(position destroy)

  def position
    if params[:position].present?
      if @training_tool.insert_at params[:position].to_i
        flash[:notice] = 'Les parcours ont été réordonnés avec succès'
      else
        flash[:danger] = 'Il y a eu un problème lors du réordonnancement'
      end
    end
    redirect_to edit_admin_training_path(@training_tool.training)
  end

  def destroy
    @training_tool.destroy
    flash[:notice] = 'Le parcours a été supprimé avec succès'
    redirect_to edit_admin_training_path(@training_tool.training)
  end

  private

  def find_training_tool
    @training_tool = TrainingTool.find params[:id]
  end
end
