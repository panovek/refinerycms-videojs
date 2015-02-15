module Refinery
  module Videos
    module Admin
      class VideosController < ::Refinery::AdminController

        crudify :'refinery/videos/video',
                :title_attribute => 'title',
                :order => 'created_at desc',
                :sortable => true

        before_filter :set_embedded, :only => [:new, :create]

        # override because acts_as_indexed dont work with utf8
        def index
          if params[:search].present?
            @videos = Video.where('LOWER(title) ILIKE ?', "%#{params[:search].downcase}%")
          else
            @videos = Video.all
          end
          @videos = @videos.order('created_at desc').paginate(:page => params[:page])
        end

        def show
          @video = Video.find(params[:id])
        end

        def new
          @video = Video.new
          @video.video_files.build
        end

        def insert
          search_all_videos if searching?
          find_all_videos
          paginate_videos
        end

        def append_to_wym
          @video = Video.find(params[:video_id])
          params['video'].each do |key, value|
            @video.config[key.to_sym] = value
          end
          @html_for_wym = @video.to_html
        end

        def dialog_preview
          @video = Video.find(params[:id].delete('video_'))
          w, h = @video.config[:width], @video.config[:height]
          @video.config[:width], @video.config[:height] = 300, 200
          @preview_html = @video.to_html
          @video.config[:width], @video.config[:height] = w, h
          @embedded = true if @video.use_shared
        end

        private

        def paginate_videos
          @videos = @videos.paginate(:page => params[:page], :per_page => Video.per_page(true))
        end

        def set_embedded
          @embedded = true if params['embedded']
        end

        def video_params
          params.require(:video).permit(:title, :poster_id, :position, :config, :embed_tag, :is_active, :use_shared, *Refinery::Videos::Video::CONFIG_OPTIONS.keys, :video_files_attributes => ['use_external', 'file', 'external_url', 'id'])
        end

      end
    end
  end
end
