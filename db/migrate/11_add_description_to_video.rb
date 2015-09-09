class AddDurationToVideo < ActiveRecord::Migration
  def up
    add_column ::Refinery::Videos::Video.table_name, :description, :string
  end

  def down
    remove_column ::Refinery::Videos::Video.table_name, :description
  end
end
