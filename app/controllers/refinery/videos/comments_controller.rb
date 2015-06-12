module Refinery
  module Videos
    class CommentsController < ::ApplicationController
      respond_to :js, :xml, :json

      def index
        @comments = Video.find(params[:id]).comments
        respond_with(@comments)
      end

      def create
        @comment = Comment.new(comment_params)
        @comment.user_id = current_refinery_user.id
        @comment.save
        respond_with @comment
      end

      def destroy
        @comment = Comment.find(params[:id])
        if @comment.owner?(current_refinery_user)
          @comment.destroy
        end
        respond_with @comment
      end

      def update
        @comment = Comment.find(params[:id])
        if @comment.owner?(current_refinery_user)
          @comment.update(comment_params)
        end
        respond_with @comment
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :video_id)
      end

    end
  end
end
