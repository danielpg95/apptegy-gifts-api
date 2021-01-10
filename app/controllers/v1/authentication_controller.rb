module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def authenticate
      # Authenticate user can be found in /services
      auth_request = AuthenticateUser.new(authentication_params)
      auth_token = auth_request.call
      if auth_token.present?
        render json: { auth_token: auth_token }
      else
        render json: { error: auth_request.errors }, status: :unauthorized
      end
    end

    private

    def authentication_params
      params.permit(:username, :password)
    end
  end
end