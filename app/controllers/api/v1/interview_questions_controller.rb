class Api::V1::InterviewQuestionsController < ApplicationController
  def index
    interview_questions = InterviewQuestion.all
    render json: interview_questions
  end
end