if defined?(Haml)
  Haml::Template.options[:format] = :html5
  Haml::Template.options[:ugly]   = true
  #Haml::Template.options[:escape_html] = true
end
