class Api::V1::JobApplicationsController < ApplicationController
  before_action :authenticate_user

  def create
    user = User.find(params[:user_id])

    job_application = user.job_applications.build(job_application_params)

    if job_application.save
      render json: JobApplicationSerializer.new(job_application), status: :ok
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(job_application.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end


  def index
    job_applications = @current_user.job_applications 
    render json: JobApplicationSerializer.new(job_applications), status: :ok
  end
  private

  def job_application_params

    params.require(:job_application).permit(
      :position_title, 
      :date_applied, 
      :status, 
      :notes, 
      :job_description, 
      :application_url, 
      :contact_information, 
      :company_id
    )
  end
end