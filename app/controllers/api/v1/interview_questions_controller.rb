class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user
  # require_relative '../../../gateways/openai_gateway'

  def show
    user_id = params[:user_id]
    job_application_id = params[:job_application_id]

    job_application = JobApplication.find_by(user_id: user_id, id: job_application_id)

    unless job_application
      render json: { error: "Job application not found" }, status: :not_found
      return
    end

    authorize job_application, :show?
    
    existing_interview_questions = InterviewQuestion.find_by(job_application_id: job_application_id)

    if existing_interview_questions.present?
      return render json: existing_interview_questions, status: :ok 
    end

    job_description = job_application.job_description
    ai_response = OpenaiGateway.new.generate_interview_questions(job_description)

    if ai_response[:success]
      render json: InterviewQuestionSerializer.format_questions(ai_response[:data], ai_response[:id]), status: 200
    else
      error_message = ErrorMessage.new("Failed to generate interview questions.", 400)
      render json: ErrorSerializer.format_error(error_message), status: :bad_request
      return
    end
  end

  # def index
  #   authorize InterviewQuestion

  #   if params[:description].blank?
  #     error_message = ErrorMessage.new("Job description is required.", 400)
  #     render json: ErrorSerializer.format_error(error_message), status: :bad_request
  #     return
  #   end

  #   api_response = OpenaiGateway.new.generate_interview_questions(params[:description]

  #   if api_response[:success]
  #     render json: InterviewQuestionSerializer.format_questions(api_response[:data], api_response[:id]), status: 200
  #   else
  #     error_message = ErrorMessage.new("Failed to generate interview questions.", 400)
  #     render json: ErrorSerializer.format_error(error_message), status: :bad_request
  #     return
  #   end
  # end

  # private

  # def interview_question_params
  #   params.require(:interview_question).permit(:question, :job_application_id)
  # rescue ActionController::ParameterMissing
  #   nil
  # end
end
