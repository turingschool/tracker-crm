require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:contacts) }
    it { should have_many(:job_applications) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
