require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:companies) }
    it { should have_many(:job_applications) }
    
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }

    it { should have_many(:contacts).dependent(:destroy) }
  end
end
