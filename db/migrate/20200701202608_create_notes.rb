class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.belongs_to :job_application, index: true
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
