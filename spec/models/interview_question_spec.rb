require 'rails_helper'

RSpec.describe InterviewQuestion, type: :model do
  describe 'associations' do
    it {should belong_to(:job_application)}
    it { should have_one(:answer_feedback) }
  end
end