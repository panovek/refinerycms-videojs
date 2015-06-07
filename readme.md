# Refinery CMS Video.js
Simple video extension for [Refinery CMS](http://refinerycms.com).
It adds a 'Videos' tab to admin menu where you can manage videos.
And adds an 'add video' link to WYMeditor on 'Pages'.

There are three ways to include videos in your project.
- You can embedded video (like youtube or vimeo iframes)
- You can upload files
- You can use link to external source

Video (instance of `Refinery::Videos::Video` model) aggregates different sources (files and links, one or many).

The instance method `Video#to_html` renders an html video tag like:

```html
<video id="my_video_1" class="video-js vjs-default-skin" controls
  preload="auto" width="640" height="264"
  poster="my_video_poster.png"
  data-setup="{}">
  <source src="oceans-clip.mp4" type='video/mp4'>
  <source src="http://video-js.zencoder.com/oceans-clip.webm" type='video/webm'>
</video>
```

This content can be added to a page in WYMeditor, or everywhere in your view like:

```erb
<div class='video'>
  <%= @my_video.to_html %>
  # OR
  <%= @my_video.to_html(width: "300px", height: "90%", extra_class: "form-control") %>
</div>
```

This extension: 
  * Uses the [Video.js](http:videojs.com) player to playback video (except embedded video, of course).
  * Allows you to manage playback configuration (poster image, width, height, autoplay, controls, etc).
  * Allows you to insert video to pages using WYMeditor, by inserting an HTML code with video (or iframe) tag.
  * Automatically downloads the video.js library on your website frontend.
  * Allows you set category of uploading video
  * Allows use postprocess background worker to encode video to uniform format after uploading
  * Generate example posters on edit video page
  * Allows setup html render size and extra styles
  * Video has creator user
  * Allows you manage and set tags to video

## Requirements
Refinery CMS version 2.0.1 or above

## Install
Open up your ``Gemfile`` and add at the bottom this line:

Get the latest version with:
```ruby
gem 'refinerycms-videojs', git: 'git@github.com:panovek/refinerycms-videojs.git'
```

Now, run: 

    bundle install

Next, to install the video extension run:

    rails generate refinery:videos

Run database migrations:

    rake db:migrate

And you're done.

## More Information
- Check out Refinery CMS [guides](http://refinerycms.com/guides)
