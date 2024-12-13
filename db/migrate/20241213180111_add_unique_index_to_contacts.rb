class AddUniqueIndexToContacts < ActiveRecord::Migration[7.1]
  def change
      add_index :contacts, [:user_id, :first_name, :last_name], unique: true, name: 'index_contacts_on_user_id_and_full_name'
  end
end
