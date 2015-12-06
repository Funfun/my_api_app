class Api::V1::SessionsController < ApplicationController
  def create
    render json: current_user
  end
end
