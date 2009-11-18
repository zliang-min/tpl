class Configuration::LDAP < Configuration
  configuration_name 'ldap'

  preference :host,               :string, :default => 'shaad00.nurun.com'
  preference :treebase,           :string, :default => 'dc=nurun,dc=com'
  preference :email_domain,       :string, :default => 'nurun.com'
  preference :position_attribute, :string, :default => 'description'
end
