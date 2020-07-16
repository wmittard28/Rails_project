class JobApplicationsController < ApplicationController
  respond_to :html, :json #formats I want responders to handle


  #/:slug/job_applications
  #job_applications_path
  def index
    redirect_to job_applications_path(current_user) unless user_exists?
    if user_is_current_user?
      @job_application = current_user.job_applications.build.tap{|job_application| job_application.build_company} #allows me to manipulate object
    end
  end

  #/:slug/job_applications
  # job_applications_path
  def create
    redirect_to job_applications_path(current_user) unless user_is_current_user?
    @job_application = @user.job_applications.build(job_application_params) #.build returns a new object of the collection type
    if job_application_dates_valid? && @job_application.save
      respond_with(@job_application, location: job_applications_path) #used location: to overrider redirect_to
    else
      render :index
    end
  end

  # /job_applications/:id
  # job_application_path
  def show
    redirect_to job_applications_path(current_user) unless job_application_exists?
    respond_with(@job_application)
  end

  # /job_applications/:id/edit
  # edit_travel_path
  def edit
    redirect_to job_applications_path(current_user) unless job_application_belongs_to_current_user?
  end


  # /job_applications/:id
  # job_application_path
  def update
    redirect_to job_applications_path(current_user) unless job_application_belongs_to_current_user?
    if job_application_dates_valid? && @job_application.update(job_application_params) then redirect_to job_applications_path(current_user)
    else
      render :edit
    end
  end


  # /job_applications/:id
  # job_application_path
  def destroy
    @job_application.destroy if job_application_belongs_to_current_user?
    redirect_to job_applications_path(current_user)
  end

  private

  def job_application_params
    params.require(:job_application).permit(:position, :location, :status, :start_date, :end_date, :company_attributes => [:name])
  end

  def job_application_exists?
    !!( @job_application = JobApplication.find_by(:id => params[:id]) ) #convert into boolean
  end

  def job_application_belongs_to_current_user?
    @job_application.user_id == current_user.id if job_application_exists?
  end

  def job_application_dates_valid?
    %w[start_date end_date].all? do |attribute| # foo_bar is notation to write an array of strings
      if job_application_params[attribute].blank? # returns true if no elements
        true
      else
        if !!( job_application_params[attribute] =~ /\A\d{4}-\d{1,2}-\d{1,2}\z/ ) # 4 #'s, 1 or 2 #'s, 1 or 2#'s, A and Z whitespace
          yyyymmdd = job_application_params[attribute].split(/\D/).map(&:to_i) #calls a method on array element, proc returns object
          !!Date.new(*yyyymmdd) rescue ( @job_application.errors.add(attribute.to_sym, "is invalid"); false ) # boolean if new date true persist, if not rescue
        else
          @job_application.errors.add(attribute.to_sym, "format is invalid"); false #to_sym returns the symbol
        end
      end
    end
  end
end
