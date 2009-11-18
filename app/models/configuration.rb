# Base class for various configurations. Code heavily borrowed from spree.
# Inherit from this class instead of using it to group configurations.
class Configuration < ActiveRecord::Base

  autoload :LDAP, 'configuration/ldap' # Ldap looks ugly

  include Singleton

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :type

  class << self
    def instance
      return @configuration if @configuration
      return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
      @configuration ||= find_or_create_by_name(configuration_name)
      @configuration
    end

    # Override this method to name the configuration
    def configuration_name name = nil
      if name
        @configuration_name = name
      else
        @configuration_name ||= self.to_s
      end
    end

    def get(key = nil)          
      key = key.to_s if key.is_a?(Symbol)
      return nil unless config = self.instance
      # preferences will be cached under the name of the class including this module (ex. Configuration::LDAP)
      prefs = Rails.cache.fetch(self.to_s) { config.preferences }
      return prefs if key.nil?
      prefs[key]
    end

    # Set the preferences as specified in a hash (like params[:preferences] from a post request)
    def set(preferences={})
      config = self.instance
      preferences.each do |key, value|
        config.set_preference(key, value)
      end
      config.save
      Rails.cache.delete(self.to_s) { config.preferences }
    end

    alias_method :[], :get
  end

end
