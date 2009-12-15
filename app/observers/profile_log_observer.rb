class ProfileLogObserver < ActiveRecord::Observer

  def after_create(log)
    create_operation log
    send_mail log unless \
      log.action == ProfileLog::ACTIONS[:new] ||
      log.operator.email == log.profile.email_of_assigned_user ||
      log.profile.email_of_assigned_user.blank?
  end

  private
    def send_mail(log)
      ProfileNotifier.deliver_state_changed_mail(log)
    end

    def create_operation(log)
      Operation.create \
        :operator => log.operator,
        :event => "_#{log.operator.displayname}_ #{action_for log} " \
                  "#{profile_description_for log} " \
                  "at #{I18n.l log.created_at, :format => :short}."
    end

    def profile_description_for(log)
      profile = log.profile
      profile_name = profile_name_for profile
      desc =
        if log.action == ProfileLog::ACTIONS[:new]
          "a new profile #{profile_name}"
        else
          "the state of profile #{profile_name} to **#{profile.state}**"
        end
      desc << " and assigned it to _#{profile.assign_to}_" unless profile.assign_to.blank?
    end

    def profile_name_for profile
      "[#{profile.name}]({{profile_path #{profile.id}}})"
    end

    def action_for log
      if log.action == ProfileLog::ACTIONS[:new]
        'added'
      else
        'changed'
      end
    end

end
