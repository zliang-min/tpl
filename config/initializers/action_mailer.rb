ActionMailer::Base.class_eval do
  self.smtp_settings = {
    :address        => 'Smtp03.nurun.com'#,
    #:user_name      => 'ndpc.user@nurun.com',
    #:authentication => 'cram_md5',
  }

  self.raise_delivery_errors = Rails.env != 'production'

  self.default_url_options[:host] = Rails.env == 'production' ? 'rms.ndpc.nurun.com' : '192.168.56.101'
end
