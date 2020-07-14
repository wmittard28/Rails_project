class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :verify_user_is_logged_in
    helper_method :current_user, :logged_in?

    def current_user
      @current_user ||= User.find_by(:id => session[:user_id]) if !!session[:user_id] #conditional assignment 
    end

    def logged_in?
      !!current_user #converts to a boolean
    end

    def verify_user_is_logged_in
      redirect_to root_path unless logged_in?
    end

    def user_exists?
      !!( @user = User.find_by(:slug => params[:slug]) )
    end

    def user_is_current_user?
      @user == current_user if user_exists?
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

end
