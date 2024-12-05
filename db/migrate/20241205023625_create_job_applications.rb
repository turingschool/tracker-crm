class CreateJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applications do |t|
      t.string :position_title
      t.date :date_applied
      t.integer :status
      t.text :notes
      t.text :job_description
      t.string :application_url
      t.text :contact_information
      t.bigint :company_id, null: true

      t.timestamps
    end
  end
end
