require 'rails_helper'

RSpec.describe JobApplicationPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.create!(name: "user" , email: "user@email.com", password: "123") }
  let(:other_user) { User.create!(name: "other_user" , email: "other_user@email.com", password: "234") }
  let(:admin) { User.create!(name: "admin" , email: "admin@email.com", password: "456") }
  
  let(:company_1) { Company.create!(
    name: 'Tech Innovators', website: 'https://techinnovators.com',
    street_address: '123 Innovation Way', city: 'San Francisco',
    state: 'CA', zip_code: '94107',
    notes: 'Reached out on LinkedIn, awaiting response.', user_id: admin.id) }

  let(:company_2) { Company.create!(
    name: 'Future Designs LLC', website: 'https://futuredesigns.com',
    street_address: '456 Future Blvd', city: 'Austin',
    state: 'TX', zip_code: '73301',
    notes: 'Submitted application for the UI Designer role.', user_id: user.id) }

  let(:company_3) { Company.create!(
    name: 'Creative Solutions Inc.', website: 'https://creativesolutions.com',
    street_address: '789 Creative Street', city: 'Seattle',
    state: 'WA', zip_code: '98101',
    notes: 'Follow up scheduled for next week.', user_id: other_user.id)}

  let(:job_app_admin) { JobApplication.create!(
    position_title: "Jr. CTO", date_applied: "2024-10-31",
    status: :submitted, notes: "Fingers crossed!",
    job_description: "Looking for Turing grad/jr dev to be CTO",
    application_url: "www.example.com",
    company_id: company_1.id, user_id: admin.id) }

  let(:job_app_user) { JobApplication.create!(
    position_title: "UI Designer", date_applied: "2024-09-15",
    status: :submitted, notes: "Submitted portfolio and waiting for feedback.",
    job_description: "Designing innovative and user-friendly interfaces.",
    application_url: "https://futuredesigns.com/jobs/ui-designer",
    company_id: company_2.id, user_id: user.id) }

  let(:job_app_other_user) { JobApplication.create!(
    position_title: "Backend Developer", date_applied: "2024-08-20",
    status: 2, notes: "Had a technical interview, awaiting decision.",
    job_description: "Developing RESTful APIs and optimizing server performance.",
    application_url: "https://creativesolutions.com/careers/backend-developer",
    company_id: company_3.id, user_id: other_user.id) }

  let(:scope) { Pundit.policy_scope!(current_user, JobApplication) }

  before(:each) do
    admin.set_role(:admin)
  end

  permissions :index? do
    it "allows a user to view all job apps when logged in" do
      expect(subject).to permit(user, JobApplication.all)
    end
  end

  permissions :create? do
    it "allows any user to create their own job app" do
      expect(subject).to permit(user, job_app_user)
      expect(subject).to permit(admin, job_app_admin)
    end
  end

  permissions :show? do
    it "allows a user to view a single one of their job apps" do
      expect(subject).to permit(user, job_app_user)
      expect(subject).not_to permit(user, job_app_admin)
    end
  end

  permissions '.scope' do
    context "when user is a :user" do
      let(:current_user) { user }
    
      it "will only allow a user to view a job app related to their user id" do
        expect(scope).to include(job_app_user)
        expect(scope).not_to include(job_app_other_user)
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
