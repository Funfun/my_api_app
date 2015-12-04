module Api
  module V1
    class EpicsController < ApplicationController
    load_and_authorize_resource

    # GET /api/v1/epics
    def index
      @epics = Epic.all

      render json: @epics
    end

    # GET /api/v1/epics/1
    def show
      @epic = Epic.find(params[:id])
      render json: @epic
    end

    # POST /api/v1/epics
    def create
      @epic = Epic.new(epic_params)

      if @epic.save
        render json: @epic, status: :created, location: api_epic_url(@epic.id)
      else
        render json: @epic.errors, status: :unprocessable_entity
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def epic_params
        params.require(:epic).permit(:title, :description, :priority)
      end
    end
  end
end
