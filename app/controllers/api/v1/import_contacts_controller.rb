module Api
  module V1
    class ImportContactsController < ApplicationController
      before_action :authenticate_user
    end
  end
end