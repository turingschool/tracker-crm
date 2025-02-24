class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user

  def index
    interview_questions = (@current_user.interview_questions)
    authorize interview_questions 
    render json: interview_questions
  end
end
