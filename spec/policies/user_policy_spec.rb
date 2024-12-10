require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }
  
  let(:user) { User.create!(name: "user" , email: "user@email.com", password: "123") }
  let(:other_user) { User.create!(name: "other_user" , email: "other_user@email.com", password: "234") }
  let(:admin) { User.create!(name: "admin" , email: "admin@email.com", password: "456") }
  
  before(:each) do
    admin.set_role(:admin)
  end

  permissions :create? do
    it "anyone can perform this action" do
      expect(subject).to permit(nil, user, admin)
    end
  end

  permissions :index? do
    it "only an :admin can view all users" do
      expect(subject).to permit(admin)
      expect(subject).not_to permit(user, other_user)

    end
  end

  permissions :show? do
    it "only an :admin can view all users individual records" do
      expect(subject).to permit(admin)
      expect(subject).not_to permit(user, other_user)
    end

    it "a :user can only view their own record" do
      expect(subject).to permit(user, user)
      expect(subject).not_to permit(user, other_user)
    end
  end

  permissions :update? do
    it "only an :admin can update all records" do
      expect(subject).to permit(admin)
      expect(subject).not_to permit(user, other_user)
    end

    it "a :user can only update their own record" do
      expect(subject).to permit(user, user)
      expect(subject).not_to permit(user, other_user)
    end
  end

  describe 'Scope' do
    let(:scope) { Pundit.policy_scope!(current_user, User) }
    let(:user) { User.create!(name: "user" , email: "user@email.com", password: "123") }
    let(:admin) { User.create!(name: "admin" , email: "admin@email.com", password: "456") }
  
    before(:each) do
      admin.set_role(:admin)
    end

    context 'when user is an :admin' do
      let(:current_user) { admin }

      it "returns all users" do
        expect(scope).to match_array(User.all)
      end
    end

    context 'when user is a :user' do
      let(:current_user) { user }

      it "returns only current users record" do
        expect(scope).to match_array([user])
        expect(scope).not_to match_array(User.all)
      end
    end
  end

end
