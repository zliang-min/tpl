# Base class for various configurations. Code heavily borrowed from spree.
# Inherit from this class instead of using it to group configurations.
class Configuration < ActiveRecord::Base

  autoload :Application, 'configuration/application'
  autoload :ProfileStatus, 'configuration/profile_status'
  autoload :LDAP, 'configuration/ldap' # Ldap looks ugly

  # does this configuration support group?
  cattr_accessor :support_group
  self.support_group = false

  # Making SIT classes to be singleton classes will course many problems,
  # so, just use these class properly, don't create/find/update/destroy them by hands.
  # Always use their `instance` method.
  #
  # include Singleton

  validates_presence_of   :name
  validates_uniqueness_of :name

  class << self
    def support_group!; self.support_group = true end

    def groups; @groups ||= [] end

    def inherited subclass
      super
      groups << subclass
    end

    def all_groups; groups.map(&:instance) end

    # Get/Set configuration name.
    # 
    # @override group_name name
    #   Set group name which is used as the name of this group of configurations.
    #   Once decided, don't change it easily, or the stored preferences will be lost
    #   unless relavant records are updated.
    #
    # @override group_name
    #   Get the group name, defaults the last part of the class name.
    def group_name(name=nil)
      if name
        @group = name
      else
        @group ||= self.name.split('::').last
      end
    end

    def group(name)
      g = groups.detect { |g| g.group_name == name }
      g ? g.instance : nil
    end

    def instance
      return @instance if @instance
      return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
      @instance ||= find_or_create_by_name(group_name)
      @instance
    end

    def get(key=nil, group=nil)
      key = key.to_s if key.is_a?(Symbol)
      return nil unless config = self.instance
      config.get key, group
    end
    alias_method :[], :get

    # Set the preferences as specified in a hash (like params[:preferences] from a post request)
    def set(preferences={}, group=nil)
      self.instance.set preferences, group
    end

    def release(group=nil)
      self.instance.release group
    end
  end

  def support_group?
    self.class.support_group
  end

  def get(key=nil, group=nil)
    group = nil if not support_group?
    # preferences will be cached under the name of the class including this module (ex. Configuration::LDAP)
    prefs = Rails.cache.fetch(cache_key(group)) { self.preferences(group) }
    return prefs if key.nil?
    prefs[key]
  end

  def set(preferences={}, group=nil)
    group = nil if not support_group?
    preferences.each do |key, value|
      set_preference(key, value, group)
    end
    if save
      Rails.cache.delete(cache_key(group)) { self.preferences(group) }
      true
    else
      false
    end
  end

  def release(group=nil)
    group = nil if not support_group?
    Rails.cache.delete cache_key(group)
  end

  private
  def cache_key(group)
    group ? "#{self.class.to_s}.#{group.to_s}" : self.class.to_s
  end

end

# Rails loads constants lazily, in order to make
# Configuration.configurations work predictably,
# require Configuration subclasses here manually.
#
# ** Loading order matters
Configuration::Application
Configuration::ProfileStatus
Configuration::LDAP
