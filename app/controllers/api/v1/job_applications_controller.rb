class Api::V1::JobApplicationsController < ApplicationController
  before_action :authenticate_user

  def index
    authorize JobApplication
    job_applications = policy_scope(JobApplication)
    render json: JobApplicationSerializer.new(job_applications), status: :ok
  end

  def create
    user = authorize User.find(params[:user_id])

    job_application = user.job_applications.build(job_application_params)

    if job_application.save
      render json: JobApplicationSerializer.new(job_application), status: :ok
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(job_application.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def show
    
    if params[:id].blank?
      render json: ErrorSerializer.format_error(ErrorMessage.new("Job application ID is missing", 400)), status: :bad_request
      return
    end

    user = User.find(params[:user_id])
    authorize user
    
    job_application = JobApplication.find_by(id: params[:id])

    if job_application.nil? || job_application.user_id != user.id
      render json: ErrorSerializer.format_error(ErrorMessage.new("Job application not found", 404)), status: :not_found
    else
      job_application_data = JobApplicationSerializer.new(job_application).serializable_hash

      job_application_data[:data][:attributes][:contacts] = JobApplicationSerializer.contacts_for(job_application)

      render json: job_application_data, status: :ok
    end
  end

  def update
    render json: ErrorSerializer.format_error(ErrorMessage.new("Job application ID is missing", 400)), status: :bad_request if params[:id].blank?

    user = User.find(params[:user_id])
    authorize user
    
    job_application = JobApplication.find_by(id: params[:id])

    if job_application.nil? || job_application.user_id != user.id
      render json: ErrorSerializer.format_error(ErrorMessage.new("Job application not found", 404)), status: :not_found
    else
      job_application.update!(job_application_params)
      render json: JobApplicationSerializer.new(job_application), status: :ok
    end
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