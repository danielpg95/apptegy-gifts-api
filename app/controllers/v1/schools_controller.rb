module V1
  class SchoolsController < ApplicationController
    before_action :initialize_validator, only: %i[create update]
    def index; end

    def create
      if @validator.valid?
        # CreateSchool can be found in /services folder
        school = CreateSchool.new(permitted_params).call
        render json: school, status: :created, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private
    
    def initialize_validator
      @validator = action_validator.new(permitted_params)
    end

    def permitted_params
      params.permit(:name, :address)
    end
  end
end