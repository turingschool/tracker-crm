class AddContactIdToJobApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :job_applications, :contact_id, :bigint
    add_foreign_key :job_applications, :contacts
  end
end
