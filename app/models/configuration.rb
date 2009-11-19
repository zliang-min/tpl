# Base class for various configurations. Code heavily borrowed from spree.
# Inherit from this class instead of using it to group configurations.
class Configuration < ActiveRecord::Base

  autoload :LDAP, 'configuration/ldap' # Ldap looks ugly

  # Making SIT classes to be singleton classes will course many problems,
  # so, just use these class properly, don't create/find/update/destroy them by hands.
  # Always use their `instance` method.
  #
  # include Singleton

  validates_presence_of   :name
  validates_uniqueness_of :name

  class << self
    def groups
      @groups ||= []
    end

    def inherited subclass
      super
      groups << subclass
    end

    def instance
      return @instance if @instance
      return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
      @instance ||= find_or_create_by_name(group_name)
      @instance
    end

    def all_groups
      groups.map(&:instance)
    end

    # Get/Set configuration name.
    # 
    # @override group_name name
    #   Set group name which is used as the name of this group of configurations.
    #   Once decided, don't change it easily, or the stored preferences will be lost
    #   unless relavant records are updated.
    #
    # @override group_name
    #   Get the group name, defaults the last part of the class name.
    def group_name name = nil
      if name
        @group = name
      else
        @group ||= self.name.split('::').last
      end
    end

    def group name
      g = groups.detect { |g| g.group_name == name }
      g ? g.instance : nil
    end

    def get(key = nil)
      key = key.to_s if key.is_a?(Symbol)
      return nil unless config = self.instance
      config.get key
    end

    # Set the preferences as specified in a hash (like params[:preferences] from a post request)
    def set(preferences={})
      self.instance.set preferences
    end

    alias_method :[], :get
  end

  def get key = nil
    # preferences will be cached under the name of the class including this module (ex. Configuration::LDAP)
    prefs = Rails.cache.fetch(self.class.to_s) { self.preferences }
    return prefs if key.nil?
    prefs[key]
  end

  def set preferences = {}
    preferences.each do |key, value|
      set_preference(key, value)
    end
    if save
      Rails.cache.delete(self.class.to_s) { self.preferences }
      true
    else
      false
    end
  end

end

# Rails loads constants lazily, in order to make
# Configuration.configurations work predictably,
# require Configuration subclasses here manually.
#
# ** Loading order matters
Configuration::LDAP
