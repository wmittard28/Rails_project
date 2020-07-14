class NotesController < ApplicationController
  respond_to :html, :json

    # /job_applications/:job_application_id/new
    # new_job_application_note_path
    def new
      redirect_to job_applications_path(current_user) unless job_application_belongs_to_current_user?
      @note = @job_application.notes.build #returns a new object of the collection type
    end


    # /job_applications/:job_application_id/notes
    # job_application_notes_path
    def create
      redirect_to job_applications_path(current_user) unless job_application_belongs_to_current_user?
      @note = @job_application.notes.build(note_params) #returns a new object of the collection type
      if @note.save then redirect_to job_application_path(@job_application)
      else render :new and return
      end
    end


    # /job_applications/:job_application_id/notes/:id (nested route)
    # job_application_note_path(:job_application_id, :id)
    def show
      redirect_to job_applications_path(current_user) unless note_exists?

      idx = @note.job_application.note_ids.index(@note.id)
      @prev_note = (idx > 0) ? @note.job_application.notes[idx-1] : @note
      @next_note = (idx < (@note.job_application.notes.size-1)) ? @note.job_application.notes[idx+1] : @note
      respond_with(@note)
    end


    # /job_applications/:job_application_id/:id/edit
    # edit_job_application_note_path
    def edit
      redirect_to job_applications_path(current_user) unless note_belongs_to_current_user?
    end


    # /job_applications/:job_application_id/notes/:id
    # job_application_note_path
    def update
      redirect_to job_applications_path(current_user) unless note_belongs_to_current_user?
      if @note.update(note_params) then redirect_to job_application_note_path(@job_application, @note)
      else render :edit and return
      end
    end


    # /job_applications/:job_application_id/notes/:id
    # job_application_note_path
    def destroy
      @note.destroy if note_exists_to_current_user?
      redirect_to job_application_path(@job_application)
    end

    private

    def note_params
      params.require(:note).permit(:title, :content)
    end

    def job_application_exists?
      !!( @job_application = JobApplication.find_by(:id => params[:job_application_id]) )
    end

    def job_application_belongs_to_current_user?
      @job_application.user_id == current_user.id if job_application_exists?
    end

    def note_exists?
      !!( @note = @job_application.notes.find_by(:id => params[:id]) ) if job_application_exists?
    end

    def note_belongs_to_current_user?
      @note.user.id == current_user.id if note_exists?
    end
  end
