# frozen_string_literal: true

class Tools::CommentsController < Tools::BaseController
  
  def create
    @comment = @tool.comments.new(comment_params)
    if @comment.save
      render json: true
    else
      # render partial: 'comments/form', locals: {}, status: 422
      render status: 422, json: { errors: @comment.errors.full_messages }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:nickname, :organization, :content)
  end
end
