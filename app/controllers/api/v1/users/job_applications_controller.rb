class Api::V1::Users::JobApplicationsController < ApplicationController
  before_action :authenticate_user

  def index
    job_applications = @current_user.job_applications 
    render json: JobApplicationSerializer.new(job_applications), status: :ok
  end
end