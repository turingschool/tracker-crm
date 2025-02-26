class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user

  def index
    interview_questions = policy_scope(InterviewQuestion) 
    authorize interview_questions
    render json: interview_questions, each_serializer: InterviewQuestionSerializer
  end

  private

  def interview_question_params
    params.require(:interview_question).permit(:question, :user_id)
  rescue ActionController::ParameterMissing
    nil
  end
end
