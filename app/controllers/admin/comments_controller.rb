class Admin::CommentsController < Admin::BaseController

  before_action :find_comment, except: [ :index ]

  def index
    params[:sort] ||= "sort_by_created_at asc"
    @comments = Comment.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def accept
    flash[:notice] = "Commentaire validée avec succès"
    begin
      @comment.accept!
    rescue AASM::InvalidTransition
      # admin click too fast and send 2 times the request. We ignore the second and send the same flash message than a success
    end
    redirect_to(current_search_path)
  end

  def reject
    flash[:notice] = "Commentaire refusée avec succès"
    begin
      @comment.reject!
    rescue AASM::InvalidTransition
      # admin click too fast and send 2 times the request. We ignore the second and send the same flash message than a success
    end
    redirect_to(current_search_path)
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Le commentaire a été supprimé avec succès"
    redirect_to admin_comments_path
  end


  private # ==================================================

  def find_comment
    @comment = Comment.find params[:id]
  end

  def current_search_path
    url_for(search_params.merge(action: :index))
  end

  def search_params
    params.permit(:sort, :page, :by_tool)
  end
  helper_method :search_params
  
end
