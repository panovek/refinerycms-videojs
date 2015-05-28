class AddPostprocess < ActiveRecord::Migration

  def change
    add_column :refinery_videos, :postprocess_is_finished, :boolean, default: false
    add_column :refinery_video_files, :postprocessed_file_uid, :string
  end

end
