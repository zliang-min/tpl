module Admin::ConfigurationHelper

  def configuration_partial conf
    "admin/configurations/#{conf.name.downcase}"
  end

end
