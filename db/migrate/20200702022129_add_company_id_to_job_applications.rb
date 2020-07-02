class AddCompanyIdToJobApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :company_id, :integer
  end
end
