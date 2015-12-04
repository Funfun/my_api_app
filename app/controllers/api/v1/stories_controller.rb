module Api
  module V1
    class StoriesController < ApplicationController
      load_and_authorize_resource except: :create

      def index
        render json: @stories
      end

      def create
        story = Story.create!(create_story_params)
        authorize! :create, story.user
        render json: story, status: :created, location: api_epic_story_url(id: story.id, epic_id: story.epic_id)
      end

      def show
        render json: @story
      end

      def update
        @story.update_attributes!(update_story_params)
        render json: @story
      end

      def destroy
        @story.destroy

        head :no_content
      end

      private
      def create_story_params
        params.require(:story).permit(:body).merge(epic_id: params[:epic_id], user_id: current_user.id)
      end

      def update_story_params
        params.require(:story).permit(:body, :status)
      end
    end
  end
end
