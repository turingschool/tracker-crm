class Api::V1::AnswerFeedbackController < ApplicationController
  
  def create
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
end
