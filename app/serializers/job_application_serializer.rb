class JobApplicationSerializer
  include JSONAPI::Serializer
  attributes :position_title,
             :date_applied,
             :status,
             :notes, 
             :job_description, 
             :application_url, 
             :contact_information, 
             :company_id
end
