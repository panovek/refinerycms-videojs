module Refinery
  module Videos
    include ActiveSupport::Configurable

    config_accessor :dragonfly_secret, :dragonfly_url_format,
                    :max_file_size, :pages_per_dialog, :pages_per_admin_index,
                    :s3_backend, :s3_bucket_name, :s3_region,
                    :s3_access_key_id, :s3_secret_access_key,
                    :datastore_root_path, :trust_file_extensions, :whitelisted_mime_types, :skin_css_class,
                    :enable_postprocess, :video_encoder_profiles, :web_encoder_profile, :enable_auto_encode_to_web_format

    self.dragonfly_secret = Refinery::Core.dragonfly_secret
    self.dragonfly_url_format = '/system/videos/:job/:basename.:format'
    self.trust_file_extensions = false
    self.max_file_size = Refinery::Videos.max_file_size || 524288000
    self.pages_per_dialog = Refinery::Videos.pages_per_dialog || 9
    self.pages_per_admin_index = Refinery::Videos.pages_per_admin_index ||20
    self.whitelisted_mime_types = Refinery::Videos.whitelisted_mime_types || %w(video/mwv video/x-ms-wmv video/mp4 video/x-flv application/ogg video/webm video/flv video/ogg video/avi application/x-troff-msvideo video/msvideo video/x-msvideo video/quicktime)
    self.skin_css_class = Refinery::Videos.skin_css_class || "vjs-default-skin"
    self.enable_postprocess = Refinery::Videos.enable_postprocess || false
    self.video_encoder_profiles = Refinery::Videos.video_encoder_profiles
    self.web_encoder_profile = Refinery::Videos.web_encoder_profile || :webm
    self.enable_auto_encode_to_web_format = Refinery::Videos.enable_auto_encode_to_web_format || false

    class << self
      def datastore_root_path
        config.datastore_root_path || (Rails.root.join('public', 'system', 'refinery', 'videos').to_s if Rails.root)
      end

      def s3_region
        config.s3_region.nil? ? Refinery::Core.s3_region : config.s3_region
      end

      def s3_backend
        config.s3_backend.nil? ? Refinery::Core.s3_backend : config.s3_backend
      end

      def s3_bucket_name
        config.s3_bucket_name.nil? ? Refinery::Core.s3_bucket_name : config.s3_bucket_name
      end

      def s3_access_key_id
        config.s3_access_key_id.nil? ? Refinery::Core.s3_access_key_id : config.s3_access_key_id
      end

      def s3_secret_access_key
        config.s3_secret_access_key.nil? ? Refinery::Core.s3_secret_access_key : config.s3_secret_access_key
      end
    end
  end
end
