class JobApplicationSerializer
  include JSONAPI::Serializer
  attributes :position_title,
             :date_applied,
             :status,
             :notes, 
             :job_description, 
             :application_url, 
             :contact_information, 
             :company_id,
             :company_name
             
  attribute :company_name do |job_application|
    job_application.company&.name
  end
end
