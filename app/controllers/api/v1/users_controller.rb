module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.all
        render json: users
      end

      def show
        user = User.find(params[:id])
        render json: user
      end

      def create
        user = User.create!(user_params)
        render json: user, status: :created
      end

      private

      def user_params
        params.require(:user).permit(:login, :password, :password_confirmation, :role_id)
      end
    end
  end
end
