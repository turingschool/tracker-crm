class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user

  def index
    interview_questions = InterviewQuestion.all
    interview_questions.each { |question| authorize question } 
    render json: interview_questions
  end
end
