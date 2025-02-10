require 'rails_helper'

RSpec.describe ContactPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.create!(name: "user" , email: "user@email.com", password: "123") }
  let(:other_user) { User.create!(name: "other_user" , email: "other_user@email.com", password: "234") }
  let(:admin) { User.create!(name: "admin" , email: "admin@email.com", password: "456") }
  let(:admin_contact) { Contact.create!(user: admin, first_name: "John", last_name: "Smith") }
  let(:user_contact) { Contact.create!(user: user, first_name: "Johno", last_name: "Smitho") }
  let(:other_user_contact) { Contact.create!(user: other_user, first_name: "Johnny", last_name: "Smithy") }
  let(:scope) { Pundit.policy_scope!(current_user, Contact) }

  before(:each) do
    admin.set_role(:admin)
  end

  permissions :index? do
    it "allows admin or any logged in user to view all contacts" do
      expect(subject).to permit(user, Contact.all)
      expect(subject).to permit(admin, Contact.all)
      expect(subject).not_to permit(nil, Contact.all)
    end
  end

  permissions :create? do
    it "allows admin or any logged in user to create a contact" do
      expect(subject).to permit(user, Contact.all)
      expect(subject).to permit(admin, Contact.all)
      expect(subject).not_to permit(nil, Contact.all)
    end
  end

  permissions :destroy? do
    it "allows a user or admin to delete a contact" do
      expect(subject).to permit(user, user_contact)
      expect(subject).to permit(admin, user_contact)
      expect(subject).to permit(admin, other_user_contact)
    end

    it "denies a user from deleting another user's contact" do
      expect(subject).not_to permit(user, other_user_contact)
    end
  end

  permissions '.scope' do
    context "when user is an :admin" do
      let(:current_user) { admin }
    
      it "returns all contacts for an admin" do
        expect(scope).to include(admin_contact, user_contact)
      end
    end

    context "when user is a :user" do
      let(:current_user) { user }

      it "returns only a user's contacts for THAT user" do
        expect(scope).to include(user_contact)
        expect(scope).not_to include(admin_contact)
      end
    end

    context "no user" do
      let(:current_user) { nil }

      it "returns nothing" do
        expect(scope).to be_empty
      end
    end
  end
end
