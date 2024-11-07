class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email

  def self.format_user_list(users)
    {
      data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              email: user.email
            }
          }
        end
      }
  end
end
