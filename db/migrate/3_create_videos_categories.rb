class CreateVideosCategories < ActiveRecord::Migration

  def up
    create_table :refinery_videos_categories do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_column :refinery_videos, :category_id, :integer

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-videos"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/videos/categories"})
    end

    drop_table :refinery_videos_categories

  end

end
