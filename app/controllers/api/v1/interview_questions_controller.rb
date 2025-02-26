class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user
  require_relative '../../../gateways/openai_gateway'

  def index
    authorize InterviewQuestion

    if params[:description].blank?
      error_message = ErrorMessage.new("Job description is required.", 400)
      render json: ErrorSerializer.format_error(error_message), status: :bad_request
      return
    end


    api_response = OpenaiGateway.new.generate_interview_questions(params[:description])
binding.pry
    if api_response[:success]
      render json: InterviewQuestionSerializer.format_questions(api_response[:data], api_response[:id]), status: 200
    else
      error_message = ErrorMessage.new("Failed to generate interview questions.", 400)
      render json: ErrorSerializer.format_error(error_message), status: :bad_request
      return
    end
  end

  private

  def interview_question_params
    params.require(:interview_question).permit(:question, :job_application_id)
  rescue ActionController::ParameterMissing
    nil
  end
end
