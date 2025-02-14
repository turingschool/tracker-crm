class JobApplicationSerializer
  include JSONAPI::Serializer
  
  attributes :position_title,
             :date_applied,
             :status,
             :notes, 
             :job_description, 
             :application_url, 
             :company_id,
             :company_name,
             :contact_id,
             :updated_at

  attribute :company_name do |job_application|
    job_application.company&.name
  end

  attribute :updated_at do |job_app|
    job_app.updated_at.strftime('%Y-%m-%d') if job_app.updated_at
  end

  attribute :contacts do |job_application|
    contacts_for(job_application)
  end

  def self.contacts_for(job_application)
    job_application.user.contacts.where(company_id: job_application.company_id).map do |contact|
      {
        id: contact.id,
        first_name: contact.first_name,
        last_name: contact.last_name,
        email: contact.email,
        phone_number: contact.phone_number,
        notes: contact.notes
      }
    end
  end
end
