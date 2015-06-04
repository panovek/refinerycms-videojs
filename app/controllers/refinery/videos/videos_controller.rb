module Refinery
  module Videos
    class VideosController < ::ApplicationController

      def increase_looked
        video = Video.find(params[:id])
        if video.present?
          Video.increment_counter(:looked_count, params[:id])
          render json: {status: :success}
        else
          render json: {status: :error}
        end
      end

      def show
        @video = Video.find(params[:id])
      end

    end
  end
end
