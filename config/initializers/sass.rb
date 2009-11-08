Compass.configuration { |conf|
  conf.environment = Rails.env

  conf.project_path = Rails.root
  #conf.sass_dir = 'app/sass'
  conf.css_dir  = 'public/stylesheets'
  conf.images_dir = 'public/images'

  # If a prefix is provided, these two pathes should be modified corespondly.
  # Any solutions?
  conf.http_stylesheets_path = '/stylesheets'
  conf.http_images_path = '/images'

  if Rails.env == 'production'
    conf.output_style = :compressed
  else
    conf.output_style = :expanded
  end

  conf.sass_options = {
    :cache => (Rails.env == 'production'),
    :cache_location => File.expand_path('tmp/sass_cache', Rails.root),
    :template_location => File.expand_path('app/sass', Rails.root)
  }

}

Sass::Plugin.options = Compass.sass_engine_options
