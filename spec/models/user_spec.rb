require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:companies) }
    it { should have_many(:job_applications) }
    it { should have_many(:contacts).dependent(:destroy) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
  end

  describe "#after_create callback" do
    it "assigns a new user the ':user' role by default after creation" do
      @new_user = User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")

      expect(@new_user.has_role?(:user)).to eq(true)
    end
  end

  describe "role methods" do
    let(:admin) {User.create!(name: "admin", email: "test@test.com", password: "123")}
    let(:regular_user) {User.create!(name: "user", email: "test1@test.com", password: "234")}

    before(:each) do
      admin.set_role :admin
      regular_user.set_role(:user)
    end

    it "#is_admin? checks if user has :admin role" do
      expect(admin.is_admin?).to eq(true)
      expect(regular_user.is_admin?).to eq(false)
    end

    it "#is_user? checks if user has :user role" do
      expect(admin.is_user?).to eq(false)
      expect(regular_user.is_user?).to eq(true)
    end

    it "#set_role changes role and ensures a user only has one role" do
      expect(admin.is_admin?).to eq(true)
      expect(admin.is_user?).to eq(false)
    end
  end
end
