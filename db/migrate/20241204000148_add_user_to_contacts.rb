class AddUserToContacts < ActiveRecord::Migration[7.1]
  def change
    add_reference :contacts, :user, null: false, foreign_key: true
  end
end
