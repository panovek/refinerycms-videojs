class AddManyPostprocessVideoType < ActiveRecord::Migration

  def up
    add_column :refinery_video_files, :postprocessed_240p_file_uid, :string
    add_column :refinery_video_files, :postprocessed_360p_file_uid, :string
    add_column :refinery_video_files, :postprocessed_480p_file_uid, :string
    add_column :refinery_video_files, :postprocessed_720p_file_uid, :string
    add_column :refinery_video_files, :postprocessed_1080p_file_uid, :string

    Refinery::Videos::Video.all.each do |video|
      video.video_files.all.each do |video_file|
        video_file.video.update(postprocess_is_finished: false)
        Refinery::Videos::PostprocessVideoWorker.perform_async(video_file.id,
                                                               Refinery::Videos.config[:web_encoder_profile],
                                                               Refinery::Videos.config[:enable_auto_encode_to_web_format]
        ) if Refinery::Videos.config[:enable_postprocess]
      end
    end

    remove_column :refinery_video_files, :postprocessed_file_uid
  end

  def down
    remove_column :refinery_video_files, :postprocessed_240p_file_uid
    remove_column :refinery_video_files, :postprocessed_360p_file_uid
    remove_column :refinery_video_files, :postprocessed_480p_file_uid
    remove_column :refinery_video_files, :postprocessed_720p_file_uid
    remove_column :refinery_video_files, :postprocessed_1080p_file_uid

    add_column :refinery_video_files, :postprocessed_file_uid, :string
  end

end
