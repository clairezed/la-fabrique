class Admin::AdminsController < Admin::BaseController

  before_action :find_admin, only: [ :edit, :update, :destroy ]

  def index
    params[:sort] ||= "email ASC"
    @admins = Admin.where.not(email: "technique@studio-hb.com").paginate(per_page: 20, page: params[:page])
  end

  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      flash[:notice] = "L'admin a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_admin_path(@admin) : admin_admins_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'admin"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @admin.update_attributes(admin_params)
      flash[:notice] = "L'admin a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_admin_path(@admin) : admin_admins_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'admin"
      render :edit
    end
  end

  def destroy
    @admin.destroy
    flash[:notice] = "L'admin a été supprimé avec succès"
    redirect_to admin_admins_path
  end


  private

  def find_admin
    @admin = Admin.find params[:id]
  end

  # strong parameters
  def admin_params
    params.require(:admin).permit(:email, :password)
  end
  
end
