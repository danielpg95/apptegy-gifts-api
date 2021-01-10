class ApplicationController < ActionController::API
  before_action :authenticate_request

  def action_validator
    Object.const_get("#{self.class}::#{action_name.camelize}Validator")
  end

  private

  def authenticate_request
    auth_request = AuthorizeApiRequest.new(request.headers)
    render json: auth_request.errors, status: :unauthorized unless auth_request.call
  end
end
