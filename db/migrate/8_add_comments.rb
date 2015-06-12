class AddComment < ActiveRecord::Migration

  def change
    create_table :refinery_videos_comments do |t|
      t.string :body
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end

end
