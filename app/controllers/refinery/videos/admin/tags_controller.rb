module Refinery
  module Videos
    module Admin
      class TagsController < ::Refinery::AdminController

        def index
          @tags = ActsAsTaggableOn::Tag.all
        end

        def create
          respond_to do |format|
            if params[:name].present?
              @tag = ActsAsTaggableOn::Tag.create(name: params[:name])
            end
            format.js
          end
        end

        def update
          if params[:id].present? && params[:new_name].present?
            tag = ActsAsTaggableOn::Tag.where(id: params[:id]).first
            tag.update(name: params[:new_name])
            render json: {status: :ok}
          else
            render json: {status: :error}
          end
        end

        def destroy
          respond_to do |format|
            if params[:id].present?
              tag = ActsAsTaggableOn::Tag.where(id: params[:id]).first
              @id = tag.id
              tag.destroy
            else
              @id = nil
            end
            format.js
          end
        end

        private

      end
    end
  end
end
