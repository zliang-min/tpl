class Configuration::ProfileStatus < Configuration
  preference :statuses, Array, :default => YAML.dump(['new'])

  def preferred_statuses
    YAML.load preferred(:statuses)
  end

  def set preferences = {}
    statuses  = preferences[:statuses]
    if statuses
      names = statuses.inject([]) do |res, (_, name)|
        res << name unless name.blank?
        res
      end
      names.uniq!
      super :statuses => names
    else
      true
    end
  end
end
