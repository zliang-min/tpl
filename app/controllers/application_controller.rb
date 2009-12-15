# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :authenticate_user!
  before_filter :set_locale

  # a convenient helper to get page param.
  # @return [Integer] page number
  def page
    (params[:page] || 1).to_i
  end

  def per_page
    Configuration::Application.get('per_page', current_user.email)
  end

  private
  def set_locale
    I18n.locale = params[:locale] unless params[:locale].blank?
  end
end
