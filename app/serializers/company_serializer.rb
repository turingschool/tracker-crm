class CompanySerializer 
  include JSONAPI::Serializer
  attributes :name, :website, :street_address, :city, :state, :zip_code, :notes
end