class Api::V1::DashboardsController < ApplicationController

  def show
    user = User.find(params[:user_id])
    authorize user
    render json: DashboardSerializer.new(user)
  end
end
