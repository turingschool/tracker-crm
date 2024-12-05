class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email

  attribute :companies do |user|
    user.companies.map do |company|
      {
        name: company.name,
        website: company.website,
        street_address: company.street_address,
        city: company.city,
        state: company.state,
        zip_code: company.zip_code,
        notes: company.notes
      }
    end
  end

  def self.format_user_list(users)
    {
      data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              email: user.email,
              companies: user.companies.map do |company| {
                name: company.name,
                website: company.website,
                street_address: company.street_address,
                city: company.city,
                state: company.state,
                zip_code: company.zip_code,
                notes: company.notes
                }
              end
            }
          }
        end
      }
  end
end
