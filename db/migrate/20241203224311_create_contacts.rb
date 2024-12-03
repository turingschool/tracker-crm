class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :company
      t.string :email
      t.string :phone_number
      t.text :notes

      t.timestamps
    end
  end
end
