class ApplicationController < ActionController::API

  def action_validator
    Object.const_get("#{self.class}::#{action_name.camelize}Validator")
  end
end
