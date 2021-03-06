module Api
  module V1
    class UsersController < ApplicationController
      load_and_authorize_resource

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
        render json: user, status: :created, location: api_epic_url(user.id)
      end

      def update
        user = User.find(params[:id])
        user.update_attributes!(user_params)

        head :no_content
      end

      def destroy
        user = User.find(params[:id])
        user.destroy

        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:login, :password, :password_confirmation, :role)
      end
    end
  end
end
