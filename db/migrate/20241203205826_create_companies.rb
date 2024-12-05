class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :website
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :notes

      t.timestamps
    end
      add_index :companies, [:user_id, :name], unique: true 
  end
end
