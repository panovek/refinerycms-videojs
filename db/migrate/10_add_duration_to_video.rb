class AddDurationToVideo < ActiveRecord::Migration
  def up
    add_column ::Refinery::Videos::Video.table_name, :duration, :string

    Refinery::Videos::Video.connection.schema_cache.clear!
    Refinery::Videos::Video.reset_column_information

    Refinery::Videos::Video.all.each do |video|
      file_duration = video.video_files.last.file.duration
      video.update_column(:duration, Time.at(file_duration).utc.strftime("#{file_duration < 3600 ? '%M:%S' : '%H:%M:%S'}"))
    end
  end

  def down
    remove_column ::Refinery::Videos::Video.table_name, :duration
  end
end
