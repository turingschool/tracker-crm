require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { User.new }
  let(:admin) { create(:user, :admin) }

  subject { described_class }

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    it "allows anyone to create a user" do
      expect(subject).to permit(nil, user, admin)
    end
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
