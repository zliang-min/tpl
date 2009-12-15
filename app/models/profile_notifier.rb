class ProfileNotifier < ActionMailer::Base
  
  def state_changed_mail(profile_log)
    profile = profile_log.profile
    sender  = profile_log.operator

    recipients profile.email_of_assigned_user
    from       "#{sender.displayname} <#{sender.email}>"
    subject    "Profile (#{profile.name}) updated"
    sent_on    Time.now
    body       :log => profile_log, :profile => profile
  end

end
