class ApplicationController < ActionController::API
  include Pundit::Authorization
  after_action :verify_authorized

  # temporary current user testing stub until we add in authentication
  def current_user
    @current_user ||= User.find_by(email: "test@test.com")
  end
end