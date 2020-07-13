class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :verify_user_is_logged_in
    helper_method :current_user, :logged_in?

    def current_user
      @current_user ||= User.find_by(:id => session[:user_id]) if !!session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def verify_user_is_logged_in
      redirect_to root_path unless logged_in?
    end

    def params_user_exists?
      !!( @user = User.find_by(:slug => params[:slug]) )
    end

end
