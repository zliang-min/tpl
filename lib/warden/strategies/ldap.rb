require 'warden'

Warden::Strategies.add(:ldap) do

  def valid?
    !!email
  end

  def authenticate!
    halt! # don't try any other strategies.

    ldap = Net::LDAP.new \
      :host => Configuration::LDAP[:host],
      :base => Configuration::LDAP[:treebase]
    mail = email
    mail << "@#{Configuration::LDAP[:email_domain]}" unless mail['@']
    ldap.auth mail, parameters[:password]
    if ldap.bind
      user_info = ldap.search(
        :attributes => [Configuration::LDAP[:position_attribute].to_sym, :physicaldeliveryofficename, :displayname, :mail, :memberof],
        :filter => Net::LDAP::Filter.eq('mail', mail)
      ).first

      fail! :invalid unless user_info.memberof.any? do |group|
        group.split(',').any? { |prop| prop = 'CN=\\#GRP_NDPC_RMS_USER' }
      end

      user = User.create_or_update_from_ldap user_info
        
      success! user
    else
      fail! :invalid
    end
  end

  def parameters
    @parameters ||= ( params[scope] || params )
  end

  def email
    parameters[:email] or parameters[:mail] or parameters[:username]
  end

end
