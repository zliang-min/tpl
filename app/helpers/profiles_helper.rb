module ProfilesHelper

  def sidebar_picture_for profile
    pic = profile.picture.exists? ? profile.picture.url : 'blue_ghost.jpg'
    [image_tag(pic), {:class => 'picture'}]
  end

end
