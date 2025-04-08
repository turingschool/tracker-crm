class Api::V1::InterviewQuestionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_job_application


  def fetch_or_create
    authorize @job_application, :show?
  
    result = InterviewQuestionGeneratorService.call(@job_application)
  
    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: ErrorSerializer.format_error(result[:error]), status: :bad_request
    end
  end

  private

  def set_job_application
    @job_application = JobApplication.find_by(id: params[:job_application_id])
    unless @job_application
      skip_authorization
      render json: { error: "Job application not found" }, status: :not_found
      return
    end
  end
end
