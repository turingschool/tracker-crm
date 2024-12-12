class ContactsSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :company_id, :email, :phone_number, :notes, :user_id
end
