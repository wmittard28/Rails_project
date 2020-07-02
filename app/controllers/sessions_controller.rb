class SessionsController < ApplicationController
    skip_before_action :verify_user_is_logged_in, :only => [:new, :create]

    # /home
    # home_path
    def index
    end

    # /login
    # login_path
    def new
      redirect_to home_path if logged_in?
      @user = User.new
    end

    # /sessions
    # sessions_path
    def create
      redirect_to home_path if logged_in?
      if !!( auth_hash = auth )
        @user = User.find_or_create_by_omniauth(auth_hash)
        if @user.persisted? then session[:user_id] = @user.id
        else render :new and return
        end
      else
        @user = User.find_by(login_query_attribute)
        if ( !!@user && @user.authenticate(user_params[:password]) )
          session[:user_id] = @user.id
        else
          @user = User.new.tap{|u| u.errors.add(:username, "or password is invalid")}
          render :new and return
        end
      end
      redirect_to job_applications_path(current_user)
    end

    # /logout
    # logout_path
    def destroy
      reset_session
      redirect_to root_path
    end

    private

    def auth
      request.env['omniauth.auth']
    end

    def login_query_attribute
      if user_params[:username].include?("@") then { :email => user_params[:username] }
      else { :username => user_params[:username] }
      end
    end
end
