module ProfilesHelper

  def sidebar_picture_for(profile)
    pic = profile.picture.exists? ? profile.picture.url : 'blue_ghost.jpg'
    [image_tag(pic), {:class => 'picture'}]
  end

  def profile_state_select_tag(options={})
    states = Configuration.group('ProfileStatus').preferred_statuses
    option_tags = options_for_select states, states.first
    select_tag(options[:name] || 'profile[state]', option_tags, options)
  end

  def assignable_users_select_tag(selected=nil, options={})
    users = Configuration.group('LDAP').authorized_users.sort_by { |u| u.displayname.first }
    selected ||= users.first.displayname.first
    option_tags = users.inject('') do |options, entry|
      name, email = entry.displayname.first, entry.mail.first
      options << %Q|<option value="#{email},#{name}"#{' selected="selected"' if name == selected}>#{name}</option>|
    end
    select_tag(options[:name] || 'profile[assign_to]', option_tags, options)
  end

  def cv_link(profile)
    attachment_link profile.cv, :class => 'cv-link'
  end

  def cv_links(profile, options = {})
    with_delete = options[:with_delete]
    profile.resumes.map do |resume|
      content_tag :div, :class => 'resume' do
        # resume may be a cv
        is_a_resume = resume.is_a?(Resume)
        link = attachment_link(is_a_resume ? resume.file : resume, :class => 'cv-link')
        id = is_a_resume ? resume.id : 0
        link <<
          check_box_tag("profile[resumes][#{id}][_delete]", '1', false, :id => "profile_resumes_#{id}__delete") <<
          "<label>#{t(:delete)}?</label>" if with_delete
        link
      end
    end.join
  end

end
