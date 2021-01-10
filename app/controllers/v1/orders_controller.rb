module V1
  class OrdersController < ApplicationController
    def index
      @validator = action_validator.new(index_params)
      if @validator.valid?
        school_orders = School.find_by(id: index_params[:school_id]).orders
        render json: school_orders, status: :ok, each_serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    def create
      @validator = action_validator.new(create_params)
      if @validator.valid?
        order = CreateOrder.new(create_params).call
        render json: order, status: :created, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    # Update method changes recipients and gift types in the order
    def update
      @validator = action_validator.new(update_params)
      if @validator.valid?
        order = UpdateOrder.new(update_params).call
        render json: order, status: :ok, serializer: Serializer
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    def destroy
      @validator = action_validator.new(destroy_params)
      if @validator.valid?
        CancelOrder.new(destroy_params).call
        render json: {}, status: :ok
      else
        render json: @validator.validation_errors, status: :bad_request
      end
    end

    private

    def index_params
      params.permit(:school_id)
    end

    def create_params
      params.permit(:school_id, recipient_ids: [], gift_types: [])
    end

    def update_params
      params.permit(:school_id, :order_id, recipient_ids: [], gift_types: [])
    end

    def destroy_params
      params.permit(:school_id, :order_id)
    end
  end
end