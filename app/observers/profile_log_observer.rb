class ProfileLogObserver < ActiveRecord::Observer

  def after_create log
    Operation.create \
      :operator => log.operator,
      :event => "_#{log.operator.displayname}_ #{action_for log} " \
                "#{profile_description_for log} " \
                "at #{I18n.l log.created_at, :format => :short}."
  end

  private
  def profile_description_for log
    profile = log.profile
    profile_name = profile_name_for profile
    if log.action == ProfileLog::ACTIONS[:new]
      "a new profile #{profile_name}"
    else
      desc = "the state of profile #{profile_name} to **#{profile.state}**"
      desc << " and assigned it to _#{profile.assign_to}_" unless profile.assign_to.blank?
      desc
    end
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
