require 'sidekiq'
require 'dragonfly-ffmpeg'

module Refinery
  module Videos
    class PostprocessVideoWorker
      include Sidekiq::Worker

      def perform(video_file_id, encode_profile)
        # TODO: dont forget about encode_profile like a HASH
        video_file = Refinery::Videos::VideoFile.find(video_file_id)
        video_file.postprocessed_file = video_file.file.encode(encode_profile)
        video_file.file_name = video_file.file_name.gsub(/\.\w+$/, ".#{encode_profile.to_s}")
        video_file.save
        video = video_file.video
        if video_file.postprocessed_file_uid.present?
          video.postprocess_is_finished = true
          video.save
        end
      end
    end
  end
end
