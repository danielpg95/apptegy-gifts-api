class ApplicationController < ActionController::API
  before_action :authenticate_request

  def action_validator
    Object.const_get("#{self.class}::#{action_name.camelize}Validator")
  end

  private

  def authenticate_request
    auth_request = AuthorizeApiRequest.new(request.headers)
    # This variable will identify which user is creating the request if authorized
    @current_user = auth_request.call
    render json: auth_request.errors, status: :unauthorized unless @current_user
  end
end
