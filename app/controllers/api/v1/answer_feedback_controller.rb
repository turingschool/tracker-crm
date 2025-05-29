class Api::V1::AnswerFeedbackController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  def create
    unless current_user
      skip_authorization
      return
    end
    
    interview_question = InterviewQuestion.find(params[:id])
    authorize interview_question, :answer_feedback?

    result = AnswerFeedbackService.call(
      interview_question_id: params[:id],
      answer: params[:answer]
    )

    if result[:success]
      
      render json: AnswerFeedbackSerializer.new(result[:data]), status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def user_not_authorized
    render json: { error: "Not authorized" }, status: :forbidden
  end
end
