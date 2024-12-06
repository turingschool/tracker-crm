class RemoveCompanyIdFromJobApplications < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_applications, :company_id, :bigint
  end
end