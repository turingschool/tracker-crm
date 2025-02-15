class DashboardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  attribute :dashboard do |user, params|
    {
      weekly_summary: params[:weekly_summary]
    }
  end
end
