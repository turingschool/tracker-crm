class ApplicationController < ActionController::API
  include Pundit::Authorization
end