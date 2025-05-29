class Api::V1::AnswerFeedbackController < ApplicationController
    def create
        feedback = AnswerFeedback.create(interview_question_id:InterviewQuestion.find(params[:interview_question_id]))
        skip_authorization
        binding.pry
        render json: {"test": true}
    end
end