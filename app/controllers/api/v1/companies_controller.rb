module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_current_user
      def create
        company = @current_user.companies.build(company_params)
        company.save!
        render json: company 
      end

      private

      def authenticate_current_user
        @current_user = User.find_by(id: session[:user_id])
        # require 'pry'; binding.pry
        unless @current_user
          render json: { error: 'Not authenticated' }, status: :unauthorized
        end
        @current_user
      end

      def company_params
        params.permit(:name, :website, :street_address, :city, :state, :zip_code, :notes)
      end
    end
  end
end