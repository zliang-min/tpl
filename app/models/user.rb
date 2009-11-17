class User < ActiveRecord::Base

  devise :rememberable

  attr_accessible :description, :physicaldeliveryofficename, :displayname 

  validates_presence_of :email
  validates_format_of :email, :allow_blank => true,
    :with => Devise::Models::Validatable::EMAIL_REGEX

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
    user.save!

    user
  end

end
