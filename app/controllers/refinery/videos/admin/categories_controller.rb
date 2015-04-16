module Refinery
  module Videos
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/videos/category',
                :title_attribute => 'name'


        protected

        def category_params
          params.require(:category).permit(:name)
        end

      end
    end
  end
end
