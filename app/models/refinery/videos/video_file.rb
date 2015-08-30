require 'dragonfly'

module Refinery
  module Videos
    class VideoFile < Refinery::Core::BaseModel
      dragonfly_accessor :file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_240p_file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_360p_file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_480p_file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_720p_file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_1080p_file, :app => :refinery_videos

      self.table_name = 'refinery_video_files'
      acts_as_indexed :fields => [:file_name, :file_ext]
      belongs_to :video

      MIME_TYPES = {'.wmv' => 'wmv', '.avi' => 'avi', '.mp4' => 'mp4', '.flv' => 'flv', '.webm' => 'webm', '.ogg' => 'ogg', '.ogv' => 'ogg'}

      ############################ Dragonfly
      delegate :ext, :size, :mime_type, :url,
               :to        => :file,
               :allow_nil => true
      #######################################

      ########################### Validations
      validates :file, :presence => true, :unless => :use_external?
      # validates :mime_type, :inclusion => { :in =>  Refinery::Videos.config[:whitelisted_mime_types],
      #                                       :message => "Wrong file mime_type" }, :if => :file_name?
      validates :external_url, :presence => true, :if => :use_external?
      #######################################

      before_save   :set_mime_type
      before_update :set_mime_type
      after_save    :set_duration, :postprocess

      def file(rate = 240)
        if Refinery::Videos.config[:enable_postprocess] && self.video.try(:postprocess_is_finished)
          case
          when rate <= 240
            self.postprocessed_240p_file
          when (241..360) === rate
            self.postprocessed_360p_file
          when (361..480) === rate
            self.postprocessed_480p_file
          when (481..720) === rate
            self.postprocessed_720p_file
          when rate >= 1080
            self.postprocessed_1080p_file
          end
        else
          self.dragonfly_attachments[:file].to_value
        end
      end

      def exist?
        use_external ? external_url.present? : file.present?
      end

      def short_info
        if use_external
           ['.link', external_url]
        else
           ['.file', file_name]
        end
      end

      def postprocess
        Refinery::Videos::PostprocessVideoWorker.perform_async(self.id,
                                                               Refinery::Videos.config[:web_encoder_profile],
                                                               Refinery::Videos.config[:enable_auto_encode_to_web_format]
        ) if Refinery::Videos.config[:enable_postprocess] && file_uid_changed?
      end

      private

      def set_duration
        if file_uid_changed? || !self.video.duration.present?
          file_duration = file.duration
          self.video.update(duration: Time.at(file_duration).utc.strftime("#{file_duration < 3600 ? '%M:%S' : '%H:%M:%S'}"))
        end
      end

      def set_mime_type
        type = use_external ? external_url.scan(/\.\w+$/) : file_name.scan(/\.\w+$/)
        if type.present? && MIME_TYPES.has_key?(type.first)
          self.file_mime_type = "video/#{MIME_TYPES[type.first]}"
        else
          self.file_mime_type = 'video/mp4'
        end
      end
    end

  end
end
