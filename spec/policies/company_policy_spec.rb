require 'rails_helper'

RSpec.describe CompanyPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.create!(name: "user", email: "user@email.com", password: "123") }
  let(:other_user) { User.create!(name: "other_user", email: "other_user@email.com", password: "234") }
  let(:admin) { User.create!(name: "admin", email: "admin@email.com", password: "456") }

  let(:company) do
    Company.create!(
      name: "Test Company",
      website: "https://testcompany.com",
      street_address: "123 Main St",
      city: "Testville",
      state: "TS",
      zip_code: "12345",
      notes: "A test company",
      user: user
    )
  end
  
  let(:other_company) do
    Company.create!(
      name: "Other Company",
      website: "https://othercompany.com",
      street_address: "456 Elm St",
      city: "Othertown",
      state: "OT",
      zip_code: "67890",
      notes: "Another test company",
      user: other_user
    )
  end

  before(:each) do
    admin.set_role(:admin)
  end

  permissions :create? do
    it "allows any logged-in user to create a company" do
      expect(subject).to permit(user, Company.new)
      expect(subject).to permit(admin, Company.new)
    end

    it "does not allow guests to create a company" do
      expect(subject).not_to permit(nil, Company.new)
    end
  end

  permissions :index? do
    it "allows an admin or a user to view all the companies" do
      expect(subject).to permit(user, Company.new)
      expect(subject).to permit(admin, Company.new)
    end
  end

  permissions ".scope" do
    let(:scope) { Pundit.policy_scope!(current_user, Company) }

    context "when the user is an admin" do
      let(:current_user) { admin }

      it "returns all companies" do
        company
        other_company
        expect(scope).to match_array(Company.all)
      end
    end

    context "when the user is a regular user" do
      let(:current_user) { user }

      it "returns only the user's companies" do
        company
        other_company
        expect(scope).to match_array([company])
      end

      it "does not return other users' companies" do
        company
        other_company
        expect(scope).not_to include(other_company)
      end
    end

    context "when no user is logged in" do
      let(:current_user) { nil }

      it "returns an empty relation" do
        company
        other_company
        expect(scope).to match_array([])
      end
    end
  end
end
