require 'sidekiq'
require 'dragonfly-ffmpeg'

module Refinery
  module Videos
    class PostprocessVideoWorker
      include Sidekiq::Worker

      def perform(video_file_id, web_encoder_profile, enable_auto_encode_to_web_format)
        video_file = Refinery::Videos::VideoFile.find(video_file_id)
        ext = video_file.file_name.downcase.scan(/\.\w+$/).first
        if enable_auto_encode_to_web_format
          unless (ext == ".mp4" && video_file.file.video_stream.downcase.include?('h264')) || (ext == ".webm")
            video_file.postprocessed_file = video_file.file.encode(web_encoder_profile.to_sym)
            video_file.file_name = video_file.file_name.gsub(/\.\w+$/, ".#{web_encoder_profile.to_s}")
            video_file.save
          end
        end
        video = video_file.video
        video.postprocess_is_finished = true
        video.save
      end
    end
  end
end
