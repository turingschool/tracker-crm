class ChangeCompanyToCompanyIdInContacts < ActiveRecord::Migration[7.1]
  def change
    remove_column :contacts, :company, :string
    add_reference :contacts, :company, foreign_key: true
  end
end
