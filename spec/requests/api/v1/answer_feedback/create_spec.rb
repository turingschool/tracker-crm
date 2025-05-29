require 'rails_helper'

RSpec.describe "Answer Feeback #Create", type: :request do
    describe "endpoints" do
        context "request is valid" do
            it "returns 201 and provides expected fields" do
                question = create(:interview_question)
                post "/api/v1/users/#{question.job_application.user.id}/job_applications/#{question.job_application.id}/interview_questions/#{question.id}/answer_feedback"
                binding.pry
            end
        end
    end
end