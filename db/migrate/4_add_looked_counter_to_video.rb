class AddLookedCountToVideos < ActiveRecord::Migration

  def up
    add_column :refinery_videos, :looked_count, :integer, default: 0
  end

  def down
    remove_column :refinery_videos, :looked_count
  end

end