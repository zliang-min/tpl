module ProfilesHelper

  def sidebar_picture_for(profile)
    pic = profile.picture.exists? ? profile.picture.url : 'blue_ghost.jpg'
    [image_tag(pic), {:class => 'picture'}]
  end

  def profile_state_select_tag(options={})
    option_tags = options_for_select Configuration.group('ProfileStatus').preferred_statuses
    select_tag(options[:name] || 'profile[state]', option_tags, options)
  end

  def assignable_users_select_tag(selected=nil, options={})
    option_tags =
      Configuration.group('LDAP').authorized_users.sort_by { |u| u.displayname.first }.
      inject('') do |options, entry|
        name, email = entry.displayname.first, entry.mail.first
        options << %Q|<option value="#{email},#{name}"#{' selected="selected"' if name == selected}>#{name}</option>|
      end
    select_tag(options[:name] || 'profile[assign_to]', option_tags, options)
  end

  def assign_info(profile)
    "#{h(profile.assign_to || 'nobody')} " \
    "(#{(profile.assigned_at || profile.updated_at).distance})"
  end

  def cv_link(profile)
    cv = @profile.cv
    name = truncate h(cv.original_filename)
    css_class =
      case cv.content_type
      when /msword/
        'word'
      when /pdf/
        'pdf'
      when /html/
        'html'
      else
        'file'
      end
    link_to name, cv.url, :class => "cv-link #{css_class}", :target => '_blank'
  end

end
