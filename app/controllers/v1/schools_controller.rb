module V1
  class SchoolsController < ApplicationController
    def create
      @validator = action_validator.new(create_params)
      if @validator.valid?
        # CreateSchool can be found in /services folder
        school = CreateSchool.new(create_params).call
        render json: school, status: :created, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    def update
      @validator = action_validator.new(update_params)
      if @validator.valid?
        # UpdateSchool can be found in /services folder
        school = UpdateSchool.new(update_params).call
        render json: school, status: :ok, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    def destroy
      @validator = action_validator.new(destroy_params)
      if @validator.valid?
        # DestroySchool can be found in /services folder
        school = DestroySchool.new(destroy_params).call
        render json: {}, status: :ok
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private

    def create_params
      params.permit(:name, :address)
    end

    def update_params
      params.permit(:id, :name, :address)
    end

    def destroy_params
      params.permit(:id)
    end
  end
end