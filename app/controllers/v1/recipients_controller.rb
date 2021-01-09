module V1
  class RecipientsController < ApplicationController
    def create
      @validator = action_validator.new(create_params)
      if @validator.valid?
        recipient = CreateRecipient.new(create_params).call
        render json: recipient, status: :created, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private

    def create_params
      params.permit(:school_id, :first_name, :last_name, :address)
    end
  end
end