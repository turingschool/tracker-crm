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
        if header.blank?
        render json: { error: "Authorization header missing" }, status: :unauthorized
        end
        token = header.split(' ').last
        render json: { error: "Token not provided" }, status: :unauthorized if token.blank?
        begin
          decoded_token = decoded_token(token)
          @current_user = User.find_by!(id: decoded_token["user_id"])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "User not found" }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
        end
      end

      def decoded_token(token)
        secret_key = Rails.application.secret_key_base
        
        begin
          decoded = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })[0]
          raise JWT::DecodeError, "Invalid token payload" if decoded["user_id"].nil?
          HashWithIndifferentAccess.new(decoded)
        rescue JWT::VerificationError
          raise JWT::DecodeError, "Token signature verification failed"
        end
      end
    end
  end
end