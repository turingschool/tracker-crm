class Api::V1::AnswerFeedbackController < ApplicationController
  def create
    authorize @job_application, :show?
  end
end

