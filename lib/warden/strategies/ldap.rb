require 'warden'

Warden::Strategies.add(:ldap) do

  def valid?
    !!email
  end

  def authenticate!
    halt! # don't try any other strategies.

    ldap = Configuration.group('LDAP')
    if user_info = ldap.find_authorized_user(email)
      if ldap.authenticate!(user_info, parameters[:password])
        user = User.create_or_update_from_ldap user_info
        success! user
      else
        fail! :invalid
      end
    else
      fail! :unauthorized
    end
  end

  def parameters
    @parameters ||= ( params[scope] || params )
  end

  def email
    parameters[:email] or parameters[:mail] or parameters[:username]
  end

end
