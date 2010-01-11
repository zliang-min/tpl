# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  GOOGLE_AJAX_LIBS_URL = "http://ajax.googleapis.com/ajax/libs".freeze

  def sidebar boxes
    render :partial => 'shared/sidebar', :locals => {:boxes => boxes}
  end

  def google_ajax_libs(*libs)
    libs = libs.first if libs.first.is_a?(Hash)
    libs.map do |lib, version|
      format = Rails.env == 'production' ? '.min' : ''
      name, script, version =
        case lib.to_sym
        when :jquery
          ['jquery', 'jquery', version || '1.3.2']
        when :jqueryui, :'jquery-ui'
          ['jqueryui', 'jquery-ui', version || '1.7.2']
        when :swfobject
          format = '_src' unless format.empty?
          ['swfobject', 'swfobject', version || '2.2']
        end

      javascript_include_tag '%s/%s/%s/%s%s.js' % [
        GOOGLE_AJAX_LIBS_URL, name, version, script, format
      ]
    end.join("\n")
  end

  # smart_javascript_include_tag 'shared/state_form', :google => [:jqueryui]
  # It loads jquery, and application.js, and application/*.js, and controller/action.js by default.
  def smart_javascript_include_tag *sources
    options = sources.last.is_a?(Hash) ? sources.pop : {}
    output = ""

    google_libs = options.delete(:google) || []
    google_libs = [google_libs] unless [Hash, Array].any?(&google_libs.method(:is_a?))
    google_libs.respond_to?(:unshift) and google_libs.unshift(:jquery) or google_libs[:jquery] = nil
    google_libs = [google_libs].flatten!
    output << google_ajax_libs(*google_libs)

    sources.unshift :app
    #sources << "#{controller.controller_path}/#{controller.action_name}"
    sources << {:cache => "#{controller.controller_path}.#{controller.action_name}"}.merge(options)
    output << javascript_include_tag(*sources)

    output
  end

  def include_all_needed_javascripts
    if @all_needed_javascripts
      smart_javascript_include_tag *@all_needed_javascripts
    end
  end

  def include_javascript_smartly *sources
    options = (@all_needed_javascripts ||= []).last.is_a?(Hash) ? @all_needed_javascripts.pop : {}
    options.update sources.pop if sources.last.is_a?(Hash)
    # TODO tricky! no matter if sources is empty, add the default path
    # to do so, check every include_javascript_smartly
    sources << template.path_without_format_and_extension if sources.empty?
    @all_needed_javascripts.concat(sources).uniq!
    @all_needed_javascripts << options
  end

  def link_jqueryui_stylesheet(theme = 'base')
    stylesheet_link_tag "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/#{theme}/jquery-ui.css", :media => 'screen'
  end

  def icon name, title
    image_tag "icons/#{name}.png", :title => title, :class => 'icon'
  end

  def link_to_icon name, title, url_options = {}, options = {}
    link_class = "icon-link-#{options.delete(:action_name) || name}"
    options[:class] = "#{link_class} #{options[:class]}"
    link_to icon(name, title), url_options, options
  end

  # @param [Boolean] only_now specifies if only show messages stored in flash.now or not. Defaults true.
  def success_or_failure_message options = {}
    cssClass =
      if msg = flash[:success]
        'success'
      elsif msg = flash[:failure]
        'error'
      end

    if msg
      msg = t(msg) unless options.values_at(:t, :translate).include?(false)
      content_tag 'div', msg, :class => cssClass
    end
  end

  def attachment_link(attachment, options = {})
    name = truncate h(attachment.original_filename)
    (css_class = "attachment-link ") <<
      case attachment.content_type
      when /word/
        'word'
      when /pdf/
        'pdf'
      when /html/
        'html'
      else
        'file'
      end
    (extra_class = options[:class]) && css_class << " #{extra_class}"
    link_to name, attachment.url, :class => css_class, :target => '_blank'
  end

  def back_url
    params[:back_url] || request.env["HTTP_REFERER"]
  end
end
