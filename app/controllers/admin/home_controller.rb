class Admin::HomeController < ApplicationController

  def index
    @configurations = Configuration.all_groups.select do |group|
      group.class != Configuration::LDAP
    end
  end

end
