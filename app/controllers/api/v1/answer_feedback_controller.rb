class Api::V1::AnswerFeedbackController < ApplicationController
  def create
    result = AnswerFeedbackService.call(
      interview_question_id: params[:interview_question_id],
      answer: params[:answer]
    )

    if result[:success]
      render json: AnswerFeedbackSerializer.new(result[:data]), status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end
end
