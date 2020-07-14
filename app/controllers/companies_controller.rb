class CompaniesController < ApplicationController

   #/slug/companies
   # companies_path
   def index
      redirect_to companies_path(current_user) unless user_exists?
    end


    # /companies/:slug
    # company_path
    def show
      redirect_to companies_path(current_user) unless company_exists?
    end

    private

    def company_exists?
      !!( @company = Company.find_by(:slug => params[:slug]) ) #converts to boolean
    end
  end
