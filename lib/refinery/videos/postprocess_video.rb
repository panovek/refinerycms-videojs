require 'sidekiq'

module Refinery
  module Videos
    class PostprocessVideoWorker
      include Sidekiq::Worker

      def perform(video_file_id)
        video_file = Refinery::Videos::VideoFile.find(video_file_id)
        video_file.postprocessed_file = video_file.file.encode(:webm)
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
