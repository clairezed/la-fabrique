class Tools::StepsController < Tools::BaseController

  def destroy
    @step = @tool.steps.find(params[:id])
    if @step.destroy
      render json: {id: params[:id]}
    else
      render status: :unprocessable_entity, json: {errors: @step.errors.full_messages}
    end
  end

end
