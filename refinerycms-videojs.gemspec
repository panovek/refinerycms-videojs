# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-videojs}
  s.version           = %q{0.6.2.0}
  s.summary           = %q{Videos extension for Refinery CMS}
  s.description       = %q{Manage videos in RefineryCMS. Use HTML5 Video.js player.}
  s.email             = %q{amishchuk@adexin.com, panov.eduard.k@gmail.com}
  s.rubyforge_project = %q{refinerycms-videojs}
  s.authors           = ['Anton Mishchuk, Eduard Panov']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"]

  s.add_dependency 'dragonfly'
  s.add_dependency 'refinerycms-core'
  s.add_dependency 'sidekiq'
  s.add_dependency 'dragonfly-ffmpeg'
  s.add_dependency 'acts-as-taggable-on'
end
