class RemoveUniqueConstraintFromContactsName < ActiveRecord::Migration[7.1]
  def change
    remove_index :contacts, name: "index_contacts_on_user_id_and_full_name"
    add_index :contacts, [:user_id, :first_name, :last_name], name: "index_contacts_on_user_id_and_full_name"
  end
end
