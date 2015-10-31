require 'sidekiq'
require 'dragonfly-ffmpeg'

module Refinery
  module Videos
    class PostprocessVideoWorker
      include Sidekiq::Worker

      def perform(video_file_id, web_encoder_profile, enable_auto_encode_to_web_format)
        video_file = Refinery::Videos::VideoFile.find(video_file_id)
        if enable_auto_encode_to_web_format
          video_file.postprocessed_240p_file = nil
          video_file.postprocessed_360p_file = nil
          video_file.postprocessed_480p_file = nil
          video_file.postprocessed_720p_file = nil
          video_file.postprocessed_1080p_file = nil
          video_file.save
          height = video_file.file.height
          video_file.postprocessed_240p_file = video_file.file.encode("#{web_encoder_profile}_240".to_sym)
          video_file.postprocessed_240p_file.name = video_file.postprocessed_240p_file.name.gsub("#{web_encoder_profile}_240", web_encoder_profile.to_s)
          video_file.save
          if height >= 360
            video_file.postprocessed_360p_file = video_file.file.encode("#{web_encoder_profile}_360".to_sym)
            video_file.postprocessed_360p_file.name = video_file.postprocessed_360p_file.name.gsub("#{web_encoder_profile}_360", web_encoder_profile.to_s)
            video_file.save
          end
          if height >= 480
            video_file.postprocessed_480p_file = video_file.file.encode("#{web_encoder_profile}_480".to_sym)
            video_file.postprocessed_480p_file.name = video_file.postprocessed_480p_file.name.gsub("#{web_encoder_profile}_480", web_encoder_profile.to_s)
            video_file.save
          end
          if height >= 720
            video_file.postprocessed_720p_file = video_file.file.encode("#{web_encoder_profile}_720".to_sym)
            video_file.postprocessed_720p_file.name = video_file.postprocessed_720p_file.name.gsub("#{web_encoder_profile}_720", web_encoder_profile.to_s)
            video_file.save
          end
          if height >= 1080
            video_file.postprocessed_1080p_file = video_file.file.encode("#{web_encoder_profile}_1080".to_sym)
            video_file.postprocessed_1080p_file.name = video_file.postprocessed_1080p_file.name.gsub("#{web_encoder_profile}_1080", web_encoder_profile.to_s)
            video_file.save
          end
          video_file.file_name = video_file.file_name.gsub(/\.\w+$/, ".#{web_encoder_profile.to_s}")
          video_file.save
        end
        video = video_file.video
        video.postprocess_is_finished = true
        video.save
      end
    end
  end
end
