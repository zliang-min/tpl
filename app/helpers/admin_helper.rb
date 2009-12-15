module AdminHelper
  def render_configuration_partial conf
    partial = conf.name.demodulize.underscore
    render :partial => "admin/configurations/#{partial}", :locals => {:configuration => conf}
  end
end
