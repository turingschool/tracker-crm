class Api::V1::DashboardsController < ApplicationController
  before_action :authenticate_user

  def show
    user = current_user
    authorize user
    weekly_summary = Dashboard.filter_weekly_summary(user)
    render json: DashboardSerializer.new(user, params: {weekly_summary: weekly_summary}), status: :ok
  end
end
