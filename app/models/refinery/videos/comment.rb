module Refinery
  module Videos
    class Comment < Refinery::Core::BaseModel

      belongs_to :video
      belongs_to :user, :class_name => '::Refinery::User'
      validates :body, :presence => true
      validates :user_id, :presence => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      def owner?(current_user)
        current_user && (self.user == current_user || current_user.has_role?(:refinery))
      end

    end
  end
end
