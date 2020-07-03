class JobApplicationsController < ApplicationController


  def index
    redirect_to job_applications_path(current_user) unless params_user_exists?
    if params_user_is_current_user?
      @job_application = current_user.job_applications.build.tap{|job_application| job_application.build_company}
    end
  end


  def create
    redirect_to job_applications_path(current_user) unless params_user_is_current_user?
    @job_application = @user.job_applications.build(job_application_params)
    if job_application_dates_valid? && @job_application.save
      respond_to do |format|
        format.html { redirect_to job_applications_path(@user) }
        format.json { render :json => @job_application }
      end
    else render :index and return
    end
  end


  def show
    redirect_to job_applications_path(current_user) unless params_job_application_exists?
    respond_to do |format|
      format.html
      format.json { render :json => @job_application }
    end
  end


  def edit
    redirect_to job_applications_path(current_user) unless params_job_application_exists_and_belongs_to_current_user?
  end


  def update
    redirect_to job_applications_path(current_user) unless params_job_application_exists_and_belongs_to_current_user?
    if job_application_dates_valid? && @job_application.update(job_application_params) then redirect_to job_applications_path(current_user)
    else render :edit and return
    end
  end


  def destroy
    @job_application.destroy if params_job_application_exists_and_belongs_to_current_user?
    redirect_to job_applications_path(current_user)
  end

  private

  def job_application_params
    params.require(:job_application).permit(:position, :location, :status, :start_date, :end_date, :company_attributes => [:name])
  end

  def params_job_application_exists?
    !!( @job_application = JobApplication.find_by(:id => params[:id]) )
  end

  def params_job_application_exists_and_belongs_to_current_user?
    @job_application.user_id == current_user.id if params_job_application_exists?
  end

  def job_application_dates_valid?
    %w[start_date end_date].all? do |attribute|
      if job_application_params[attribute].blank?
        true
      else
        if !!( job_application_params[attribute] =~ /\A\d{4}-\d{1,2}-\d{1,2}\z/ )
          yyyymmdd = job_application_params[attribute].split(/\D/).map(&:to_i)
          !!Date.new(*yyyymmdd) rescue ( @job_application.errors.add(attribute.to_sym, "is invalid"); false )
        else
          @job_application.errors.add(attribute.to_sym, "format is invalid"); false
        end
      end
    end
  end
end