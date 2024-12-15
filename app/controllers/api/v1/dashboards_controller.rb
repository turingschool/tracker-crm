class Api::V1::DashboardsController < ApplicationController
  before_action :authenticate_user

  def show
    user = current_user
    authorize user
    render json: DashboardSerializer.new(user), status: :ok
  end
end
