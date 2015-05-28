require 'dragonfly'

module Refinery
  module Videos
    class VideoFile < Refinery::Core::BaseModel
      dragonfly_accessor :file, :app => :refinery_videos
      dragonfly_accessor :postprocessed_file, :app => :refinery_videos

      self.table_name = 'refinery_video_files'
      acts_as_indexed :fields => [:file_name, :file_ext]
      belongs_to :video

      MIME_TYPES = {'.avi' => 'avi', '.mp4' => 'mp4', '.flv' => 'flv', '.webm' => 'webm', '.ogg' => 'ogg', '.ogv' => 'ogg'}

      ############################ Dragonfly
      delegate :ext, :size, :mime_type, :url,
               :to        => :file,
               :allow_nil => true
      #######################################

      ########################### Validations
      validates :file, :presence => true, :unless => :use_external?
      validates :mime_type, :inclusion => { :in =>  Refinery::Videos.config[:whitelisted_mime_types],
                                            :message => "Wrong file mime_type" }, :if => :file_name?
      validates :external_url, :presence => true, :if => :use_external?
      #######################################

      before_save   :set_mime_type
      before_update :set_mime_type
      after_save    :postprocess

      def file
        (Refinery::Videos.config[:enable_postprocess] && self.video.try(:postprocess_is_finished) && self.postprocessed_file.present?) ? self.postprocessed_file : self.dragonfly_attachments[:file].to_value
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
                                                               Refinery::Videos.config[:video_encoder_profile].is_a?(Hash) ? :custom_profile : Refinery::Videos.config[:video_encoder_profile],
                                                               MIME_TYPES.has_key?(Refinery::Videos.config[:video_encoder_profile]) ? "video/#{Refinery::Videos.config[:video_encoder_profile]}" : 'video/mp4'
        ) if Refinery::Videos.config[:enable_postprocess] && file_uid_changed?
      end

      private

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
