class Api::V1::JobApplicationsController < ApplicationController
  def create
    job_application = JobApplication.new(job_application_params)
    # require 'pry'; binding.pry
    if job_application.save
      render json: JobApplicationSerializer.new(job_application), status: :ok
    else
      render json: ErrorSerializer.new(job_application.errors), status: :unprocessable_entity
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