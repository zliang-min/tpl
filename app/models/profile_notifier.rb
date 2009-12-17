class ProfileNotifier < ActionMailer::Base
  
  def state_changed_mail(profile_log)
    profile = profile_log.profile
    sender  = profile_log.operator

    recipients profile.email_of_assigned_user
    from       "#{sender.displayname} <#{sender.email}>"
    subject    "Profile #{name_for profile} updated"
    sent_on    Time.zone.now
    body       :log => profile_log, :profile => profile
  end

  def appointment(profile_log, appointment)
    profile = profile_log.profile
    sender  = profile_log.operator

    recipients profile.email_of_assigned_user
    from       "#{sender.displayname} <#{sender.email}>"
    subject    "#{profile.state} appointment with #{name_for profile}"
    sent_on    Time.zone.now
    body       :profile => profile, :sender => sender,
               :dtstart => Time.zone.parse(appointment[:start_time]),
               :location => appointment[:location],
               :feedback => (profile_log.feedback && profile_log.feedback.content)
  end

  private
  def name_for(profile)
    "#{profile.name}#{"(%s)" % profile.chinese_name unless profile.chinese_name.blank?}"
  end

end
