class RemoveContactInformationFromJobApplications < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_applications, :contact_information, :text
  end
end
