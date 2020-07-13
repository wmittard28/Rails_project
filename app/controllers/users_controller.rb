class UsersController < ApplicationController

    skip_before_action :verify_user_is_logged_in, :only => [:new, :create]


  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end


  def create
    redirect_to home_path if logged_in?
    @user = User.new(user_params)
    if @user.save then session[:user_id] = @user.id
    else render :new and return
    end
    redirect_to job_applications_path(current_user)
  end


  def show
    redirect_to user_path(current_user) unless params_user_is_current_user?
  end


  def edit
    redirect_to user_path(current_user) unless params_user_is_current_user?
  end


  def update
    redirect_to user_path(current_user) unless params_user_is_current_user?
    if params[:other][:current_password].present? && !!@user.authenticate(params[:other][:current_password])
      if @user.update(user_params)
        redirect_to user_path(current_user)
      else
        @user.slug = current_user.slug
        render :edit and return
      end
    else
      @user.errors.add(:current_password, "is invalid")
      render :edit and return
    end
  end


  def destroy
    @user.destroy if params_user_is_current_user?
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def params_user_is_current_user?
    @user == current_user if params_user_exists?
  end

end
