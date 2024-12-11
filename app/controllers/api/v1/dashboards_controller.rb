class Api::V1::DashboardsController < ApplicationController

  def show
    user = User.find(params[:id])
    authorize user
    render json: DashboardSerializer.new(user)
  end
end
