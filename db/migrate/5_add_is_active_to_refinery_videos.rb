class AddIsActiveToRefineryVideos < ActiveRecord::Migration

  def change
    add_column :refinery_videos, :is_active, :boolean, default: false
  end

end
