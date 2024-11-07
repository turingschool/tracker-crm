class ChangeUsersColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :username, :email
  end
end
