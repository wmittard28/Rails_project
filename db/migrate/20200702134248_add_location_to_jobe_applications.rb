class AddLocationToJobeApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :location, :string
  end
end
