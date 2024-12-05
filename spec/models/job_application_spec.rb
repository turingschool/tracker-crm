require "rails_helper"

RSpec.describe JobApplication, type: :model do
  describe "validations" do
    it { should validate_presence_of(:position_title) }
    it { should validate_presence_of(:date_applied) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:notes) }
    it { should validate_presence_of(:job_description) }
    it { should validate_presence_of(:application_url) }
    it { should validate_presence_of(:contact_information) }
    it { should validate_presence_of(:company_id) }
  end

  describe "associations" do
    it { should belong_to(:company) }
  end
end