class Configuration::ProfileStatus < Configuration
  preference :statuses, Array, :default => YAML.dump(['new'])
  preference :special_state, :string

  SPECIAL_STATES =
    Class.new do
      STATES = [[:closed, 'closed', 'auto_hide']]

      STATES.each do |state, default, desc|
        define_method(state) { state }
      end

      def each
        STATES.each { |state, default, desc| yield state }
      end

      def each_with_desc
        STATES.each { |state, default, desc| yield state, desc }
      end

      def each_with_default
        STATES.each { |state, default, desc| yield state, default }
      end
    end.new.freeze

  def set_default_special_states
    SPECIAL_STATES.each_with_default do |state, default|
      set_preference :special_state, default, state unless preferred(:special_state, state)
    end
    save
  end

  def special_state_name_for(state)
    preferred :special_state, SPECIAL_STATES.send(state)
  end

  def preferred_statuses
    YAML.load get('statuses')
  end

  def set(preferences={}, group=nil)
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

Configuration::ProfileStatus.instance.set_default_special_states if Configuration::ProfileStatus.instance
