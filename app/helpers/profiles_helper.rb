module ProfilesHelper

  def sidebar_picture_for profile
    pic = profile.picture.exists? ? profile.picture.url : 'blue_ghost.jpg'
    [image_tag(pic), {:class => 'picture'}]
  end

  def profile_events_links profile
    unless (events = profile.state_events).blank?
      content_tag 'ul', :class => 'horizontal' do
        links = profile_event_link profile, events.shift
        events.each do |event|
          links << content_tag('li', '|', :class => 'separator')
          links << profile_event_link(profile, event)
        end
        links
      end
    end
  end

  private
  def profile_event_link profile, event
    content_tag 'li' do
      link_to event, handle_profile_path(:id => profile.id, :event => event), :class => 'event'
    end
  end

end
