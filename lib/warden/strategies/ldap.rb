require 'warden'

Warden::Strategies.add(:ldap) do

  def valid?
    p = params[scope] || params
    p[:mail] or p[:email] or p[:username]
  end

  def authenticate!
    halt! # don't try any other strategies.

    p = params[scope] || params
    ldap = Net::LDAP.new :host => 'shaad00.nurun.com', :base => 'dc=nurun,dc=com'
    mail = p[:mail] || p[:email] || p[:username]
    mail << '@nurun.com' unless mail['@']
    ldap.auth mail, p[:password]
    if ldap.bind
      user = User.create_or_update_from_ldap \
        ldap.search(
          :attributes => [:description, :physicaldeliveryofficename, :displayname, :mail],
          :filter => Net::LDAP::Filter.eq('mail', mail)
        ).first
      success! user
    else
      fail! :unauthenticated
    end
  end

end
