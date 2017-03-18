class Admin::TagsController < Admin::BaseController

  before_action :find_tag, only: [ :edit, :update, :position, :destroy ]

  def index
    params[:sort] ||= "sort_by_position asc"
    @tags = Tag.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @tag = Tag.new
    @tag.build_seo
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = "Le mot-clé a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_tag_path(@tag) : admin_tags_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du mot-clé"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @tag.update_attributes(tag_params)
      flash[:notice] = "Le mot-clé a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_tag_path(@tag) : admin_tags_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du mot-clé"
      render :edit
    end
  end
  
  def position
    if params[:position].present?
      @tag.insert_at params[:position].to_i 
      flash[:notice] = "Les mot-clés ont été réordonnés avec succès"
    end
    redirect_to admin_tags_path
  end

  def destroy
    begin
      flash[:notice] = "Le mot-clé a été supprimé avec succès" if @tag.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Ce mot-clé ne peut être supprimé car des éléments lui sont dépendants"
    end
    redirect_to admin_tags_path
  end

  # def destroy
  #   @tag.destroy
  #   flash[:notice] = "Le mot-clé a été supprimée avec succès"
  #   redirect_to admin_tags_path
  # end


  private

  def find_tag
    @tag = Tag.from_param params[:id]
  end

  # strong parameters
  def tag_params
    params.require(:tag).permit(:title, :enabled, seo_attributes: [:slug, :title, :keywords, :description, :id])
  end
  
end
