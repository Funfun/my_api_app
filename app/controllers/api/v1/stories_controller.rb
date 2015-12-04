module Api
  module V1
    class StoriesController < ApplicationController
      load_and_authorize_resource except: :create

      def index
        stories = Story.where(epic_id: params[:epic_id])

        render json: stories
      end

      def create
        story = Story.create!(create_story_params)
        authorize! :create, story.user
        render json: story, status: :created, location: api_epic_story_url(id: story.id, epic_id: story.epic_id)
      end

      def show
        story = Story.find(params[:id])
        render json: story
      end

      def update

      end

      def destroy

      end

      private
      def create_story_params
        params.require(:story).permit(:body).merge(epic_id: params[:epic_id], user_id: current_user.id)
      end
    end
  end
end
