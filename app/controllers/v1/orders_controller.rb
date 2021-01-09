module V1
  class OrdersController < ApplicationController
    def create
      @validator = action_validator.new(create_params)
      if @validator.valid?
        order = CreateOrder.new(create_params).call
        render json: order, status: :created, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private

    def create_params
      params.permit(:school_id, recipient_ids: [], gift_types: [])
    end
  end
end