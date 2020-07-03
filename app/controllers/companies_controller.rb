class CompaniesController < ApplicationController

    def index
      redirect_to companies_path(current_user) unless params_user_exists?
    end


    def show
      redirect_to companies_path(current_user) unless params_company_exists?
    end

    private

    def params_company_exists?
      !!( @company = Company.find_by(:slug => params[:slug]) )
    end
  end
