class Configuration::LDAP < Configuration
  preference :host,               :string, :default => 'shaad00.nurun.com'
  preference :treebase,           :string, :default => 'dc=nurun,dc=com'
  preference :email_domain,       :string, :default => 'nurun.com'
  preference :position_attribute, :string, :default => 'description'
  preference :username,           :string, :default => 'ndpc.user'
  preference :password,           :string, :default => 'passw0rd'
  preference :authorized_group,   :string, :default => 'CN=\\#GRP_NDPC_RMS_USER,OU=Groups,OU=NDPC,DC=nurun,DC=com'

  def ldap_conn
    @ldap_conn ||= 
      Net::LDAP.new \
        :host => Configuration::LDAP[:host],
        :base => Configuration::LDAP[:treebase],
        :auth => {
          :method => :simple,
          :username => '%s@%s' % [
            Configuration::LDAP[:username], Configuration::LDAP[:email_domain]
          ],
          :password => Configuration::LDAP[:password]
        }
    @ldap_conn.dup
  end

  # @return [Array<Net::LDAP::Entry>] authorized users
  def authorized_users
    ldap_conn.search \
      :filter => objectclass_filter & authorization_filter,
      :attributes => [:mail, :displayname]
  end

  # @return [Boolean]
  def authenticate!(ldap_entry_or_dn, password)
    dn = ldap_entry_or_dn.is_a?(String) ? ldap_entry_or_dn : ldap_entry_or_dn.dn
    ldap_conn.bind_as :base => dn, :password => password
  end

  def find_authorized_user(email)
    ldap_conn.search(
      :filter => credential_filter(email) & authorization_filter,
      :attributes => user_attributes
    ).first
  end

  private
    # @private
    def credential_filter credential
      credential = credential.to_s
      credential = credential + "@#{get 'email_domain'}" unless credential['@']
      Net::LDAP::Filter.eq 'mail', credential
    end

    # @private
    def authorization_filter
      @authorization_filter ||= Net::LDAP::Filter.eq('memberof', get('authorized_group'))
    end

    # @private
    def objectclass_filter
      @objectclass_filter ||= Net::LDAP::Filter.eq('objectclass', 'organizationalPerson')
    end

    def user_attributes
      @user_attributes ||=
        [Configuration::LDAP[:position_attribute].to_sym,
         :physicaldeliveryofficename, :displayname, :mail]
    end
end
