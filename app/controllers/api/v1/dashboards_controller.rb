class Api::V1::DashboardsController < ApplicationController

  def show
    user = authorize User.find(params[:user_id])
    render json: DashboardSerializer.new(user)
  end
end
