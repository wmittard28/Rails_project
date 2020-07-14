class HomeController < ApplicationController

    skip_before_action :verify_user_is_logged_in #Don't need to verify login for registration 

  # /
  # root_path
  def registration
    redirect_to home_path if logged_in?
    @user = User.new
  end


end
