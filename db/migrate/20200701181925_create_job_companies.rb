class CreateJobCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :job_companies do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
  end
end
