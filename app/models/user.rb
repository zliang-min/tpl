class User < ActiveRecord::Base

  devise :rememberable

  attr_accessible :position, :physicaldeliveryofficename, :displayname 

  validates_presence_of :email
  validates_format_of :email, :allow_blank => true,
    :with => Devise::Models::Validatable::EMAIL_REGEX

  has_many :positions,    :dependent => :nullify
  has_many :profile_logs, :dependent => :nullify
  has_many :operations,   :dependent => :nullify

  # @param [Net::LDAP::Entry] a ldap entry which consists of a user's info. The entry should at least have a *mail* attribute.
  def self.create_or_update_from_ldap ldap_entry
    attrs = {}
    ldap_entry.each { |attr, values|
      attrs[attr.to_sym] = values.first
    }

    user = self.find_by_email attrs[:mail]
    unless user
      user = self.new
      user.email = attrs[:mail]
    end
    user.attributes = attrs
    user.position = attrs[Configuration::LDAP[:position_attribute].to_sym]
    user.save!

    user
  end

end
