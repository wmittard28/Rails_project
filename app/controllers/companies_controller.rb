class CompaniesController < ApplicationController

    def index
      redirect_to companies_path(current_user) unless user_exists?
    end


    def show
      redirect_to companies_path(current_user) unless company_exists?
    end

    private

    def company_exists?
      !!( @company = Company.find_by(:slug => params[:slug]) ) #company exists (true || false)
    end
  end
