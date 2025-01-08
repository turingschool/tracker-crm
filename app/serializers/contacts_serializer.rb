class ContactsSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :company_id, :email, :phone_number, :notes, :user_id

  attribute :company do |object|
    company = object.company
    if company
      {
        id: company.id,
        name: company.name,
        website: company.website,
        street_address: company.street_address,
        city: company.city,
        state: company.state,
        zip_code: company.zip_code,
        notes: company.notes
      }
    else
      nil
    end
  end
end
