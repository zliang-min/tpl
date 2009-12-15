class Admin::ConfigurationsController < ApplicationController

  before_filter :find_configuration

  def show
    redirect_to admin_root_path
  end

  def update
    if @configuration.set(params[@configuration.name], current_user.email)
      flash[:success] = 'admin.configurations.update.success'
    else
      flash[:failure] = 'admin.configurations.update.failure'
    end

    redirect_to admin_root_path
  end

  private
  def find_configuration
    if @configuration = Configuration.group(params[:id])
      flash[:selected_configuration] = @configuration
    else
      render :nothing => true, :status => 404
    end
  end

end
