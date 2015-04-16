module Refinery
  module Videos
    class Category < Refinery::Core::BaseModel

      has_many :video, :dependent => :destroy
      validates :name, :presence => true, :uniqueness => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
