class AddCompanyIdToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :company_id, :integer
  end
end
