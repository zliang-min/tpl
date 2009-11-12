# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def sidebar boxes
    render :partial => 'shared/sidebar', :locals => {:boxes => boxes}
  end

  def include_google_jsapi packages
    callback = packages.delete(:callback) || 'onLoadCallback'
    scripts = %Q'<script type="text/javascript" src="http://www.google.com/jsapi"></script>\n'
    scripts << %Q'<script type="text/javascript">\n'
    scripts << "//<![CDATA[\n"
    scripts << packages.map do |p, o|
      o = {:version => o} unless o.respond_to?(:keys)
      version = o.delete :version
      
      if o.blank?
        "google.load('#{p}', '#{version}');"
      else
        "google.load('#{p}', '#{version}', #{o.to_json});"
      end
    end.join

    scripts << "google.setOnLoadCallback(#{callback});\n"
    scripts << "//]]>\n</script>"
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
end
