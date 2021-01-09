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

    def update
      @validator = action_validator.new(update_params)
      if @validator.valid?
        recipient = UpdateRecipient.new(update_params).call
        render json: recipient, status: :ok, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private

    def create_params
      params.permit(:school_id, :first_name, :last_name, :address)
    end

    # This is assuming that as the school id is on the url, the recipient id is sent in the body as :id,
    # following the specification of the url on the exercise
    def update_params
      params.permit(:school_id, :id, :first_name, :last_name, :address)
    end
  end
end