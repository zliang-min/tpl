module AdminHelper
  def render_configuration_partial conf
    case conf
    when Configuration::ProfileStatus
      render :partial => 'admin/configurations/profile_status', :locals => {:configuration => conf}
    else
      render :partial => 'admin/configurations/edit', :locals => {:configuration => conf}
    end
  end
end
