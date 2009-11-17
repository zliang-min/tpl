class ProfileLogObserver < ActiveRecord::Observer

  def after_create log
    Operation.create \
      :operator => log.operator,
      :event => "_#{log.operator.displayname}_ has #{action_for log} " \
                "#{profile_description log} " \
                "at #{I18n.l log.created_at, :format => :short}."
  end

  private
  def profile_description log
    profile_name = profile_name log.profile
    if log.action == ProfileLog::NEW_ACTION
      "a new profile #{profile_name}"
    else
      "profile #{profile_name}"
    end
  end

  def profile_name profile
    "[#{profile.name}]({{profile_path #{profile.id}}})"
  end

  def action_for log
    log.action + 'ed'
  end

end
