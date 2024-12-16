class CompanySerializer 
  include JSONAPI::Serializer
  attributes :name, :website, :street_address, :city, :state, :zip_code, :notes

  attribute :contacts do |company|
    company.contacts.map do |contact|
      {
        first_name: contact.first_name,
        last_name: contact.last_name,
        email: contact.email,
        phone_number: contact.phone_number,
        notes: contact.notes
      }
    end
  end
end