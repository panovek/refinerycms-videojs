require 'dragonfly'

module Refinery
  module Videos
    class Video < Refinery::Core::BaseModel

      self.table_name = 'refinery_videos'
      acts_as_indexed :fields => [:title]
      acts_as_taggable

      validates :title, :presence => true
      validate :one_source

      has_many :video_files, :dependent => :destroy
      has_many :comments, :dependent => :destroy

      accepts_nested_attributes_for :video_files

      belongs_to :poster, :class_name => '::Refinery::Image'
      belongs_to :created_by, :class_name => '::Refinery::User'
      belongs_to :category
      accepts_nested_attributes_for :poster

      scope :published, -> { where(is_active: true).order('created_at desc') }

      ################## Video config options
      serialize :config, Hash
      CONFIG_OPTIONS = {
          :autoplay => "false", :width => "300", :height => "187",
          :controls => "true", :preload => "false", :loop => "false"
      }

      # Create getters and setters
      CONFIG_OPTIONS.keys.each do |option|
        define_method option do
          self.config[option]
        end
        define_method "#{option}=" do |value|
          self.config[option] = value
        end
      end
      #######################################

      ########################### Callbacks
      after_initialize :set_default_config
      #####################################

      #####
      # params{width: 300, height: 300, extra_class: "form-control"}
      # params{width: "300px", height: "90%", extra_class: "form-control"}
      #####
      def to_html(params = {})
        if use_shared
          update_from_config
          return embed_tag.html_safe
        end

        data_setup = []
        CONFIG_OPTIONS.keys.each do |option|
          if option && (option != :width && option != :height && option != :preload)
            data_setup << "\"#{option}\": #{config[option] || '\"auto\"'}"
          end
        end
        if config[:preload] == 'false'
          data_setup << "\"preload\": \"metadata\""
        else
          data_setup << "\"preload\": \"auto\""
        end

        data_setup << "\"poster\": \"#{poster.url}\"" if poster
        sources = []
        video_files.each do |file|
          if file.use_external
            sources << ["<source src='#{file.external_url}' type='#{file.file_mime_type}'/>"]
          else
            sources << ["<source src='#{Refinery::Videos.s3_backend ? file.file.remote_url : file.file.url}' type='#{file.file_mime_type}'/>"]
          end if file.exist?
        end
        width = params[:width].present? ? (params[:width].to_s.match(/\d+px|\d+%/) ? params[:width] : "#{params[:width]}px") : (config[:width].present? ? "#{config[:width]}px" : "#{CONFIG_OPTIONS[:width]}px")
        height = params[:height].present? ? (params[:height].to_s.match(/\d+px|\d+%/) ? params[:height] : "#{params[:height]}px") : (config[:height].present? ? "#{config[:height]}px" : "#{CONFIG_OPTIONS[:height]}px")
        html = %Q{<video id="video_#{self.id}" data-id=#{self.id} class="video-js #{Refinery::Videos.skin_css_class} #{params[:extra_class]}" width="#{width}" height="#{height}" data-setup=' {#{data_setup.join(',')}}'>#{sources.join}</video>}

        html.html_safe
      end


      def short_info
        return [['.shared_source', embed_tag.scan(/src=".+?"/).first]] if use_shared
        info = []
        video_files.each do |file|
          info << file.short_info
        end

        info
      end

      ####################################class methods
      class << self
        def per_page(dialog = false)
          dialog ? Videos.pages_per_dialog : Videos.pages_per_admin_index
        end
      end
      #################################################

      private

      def set_default_config
        if new_record? && config.empty?
          CONFIG_OPTIONS.each do |option, value|
            self.send("#{option}=", value)
          end
        end
      end

      def update_from_config
        embed_tag.gsub!(/width="(\d*)?"/, "width=\"#{config[:width]}\"")
        embed_tag.gsub!(/height="(\d*)?"/, "height=\"#{config[:height]}\"")
        #fix iframe overlay
        if embed_tag.include? 'iframe'
          embed_tag =~ /src="(\S+)"/
          embed_tag.gsub!(/src="\S+"/, "src=\"#{$1}?wmode=transparent\"")
        end
      end

      def one_source
        errors.add(:embed_tag, :empty_embed_tag) if use_shared && embed_tag.nil?
        errors.add(:video_files, :empty_video_files) if !use_shared && video_files.empty?
      end

    end

  end
end
