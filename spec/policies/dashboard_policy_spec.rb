require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.create!(name: "user" , email: "user@email.com", password: "123") }
  let(:other_user) { User.create!(name: "other_user" , email: "other_user@email.com", password: "234") }

  permissions :show? do
    it "allows a user to view only their own dashboard" do
      expect(subject).to permit(user, user)
      expect(subject).not_to permit(user, other_user)
    end
  end
end