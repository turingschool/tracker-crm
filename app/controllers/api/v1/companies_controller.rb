module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_user

      def create
        company = @current_user.companies.build(company_params)
        if company.save
          render json: CompanySerializer.new(company), status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(company.errors.full_messages.to_sentence, 422)), status: :unprocessable_entity
        end
      end

      private

      def company_params
        params.permit(:name, :website, :street_address, :city, :state, :zip_code, :notes)
      end

      def authenticate_user
        header = request.headers["Authorization"]
        token = header.split(' ').last if header
        begin
          decoded_token = decoded_token(token)
          @current_user = User.find_by(decoded_token["user_id"])
        rescue 
          render json: { error: "Not authenticated" }, status: :unauthorized
        end
      end

      def decoded_token(token)
        JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0].symbolize_keys
      end
    end
  end
end