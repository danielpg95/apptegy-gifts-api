module V1
  class PingsController < ApplicationController
    def show
      render json: "pong", status: :ok
    end
  end
end