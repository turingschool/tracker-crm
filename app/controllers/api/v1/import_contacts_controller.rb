module Api
  module V1
    class ImportContactsController < ApplicationController
      before_action :authenticate_user
      before_action :set_user

      # def import
      #   contacts_params = params[:contacts]
      # end
    end
  end
end