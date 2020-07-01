class CreateJobApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :job_applications do |t|
      t.belongs_to :user, index: true
      t.string :position
      t.string :status
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
