class AddUserIdToJobApplications < ActiveRecord::Migration[7.1]
  def change
    add_reference :job_applications, :user, null: false, foreign_key: true
  end
end
