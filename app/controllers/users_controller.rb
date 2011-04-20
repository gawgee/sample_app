class UsersController < ApplicationController
  before_filter :authenticate, :only=>[:index, :edit, :update]
  before_filter :correct_user, :only=>[:edit, :update]
  before_filter :admin_user,   :only=>:destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    redirect_to root_path unless !signed_in?
    @user = User.new
    @title = "Sign up"
  end

  def create
    redirect_to root_path unless !signed_in?
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      render 'new'
    end
  end # end of create

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash[:notice] = "admin cannot destroy himself"
    else
      @user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      if signed_in?
        redirect_to(root_path) unless current_user.admin?
      else
        redirect_to(signin_path)
      end
    end
end
