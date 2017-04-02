# frozen_string_literal: true

class Tools::TrainingsController < Tools::BaseController
  
  def show
    @training = @tool.trainings.from_param params[:id]
    @tools = @training.tools.enabled
                          .apply_filters(params)
                          .includes(:axis)
                          .includes(:seo)
                          .includes(:tool_category)
                          .includes(:tool_tags)
                          .includes(:tags)
                          .paginate(per_page: 20, page: params[:page])
  end

  private

end