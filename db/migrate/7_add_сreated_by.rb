class AddCreatedBy < ActiveRecord::Migration

  def change
    add_column :refinery_videos, :created_by_id, :integer, default: nil
  end

end
