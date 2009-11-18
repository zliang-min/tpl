class Admin::ConfigurationsController < ApplicationController

  def show
    Configuration.const_get params[:id]
    flash[:selected_configuration] = params[:id]
    redirect_to admin_root_path
  rescue NameError
    render :nothing => true, :status => 404
  end

end
