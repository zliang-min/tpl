class Admin::HomeController < ApplicationController

  def index
    @configurations = Configuration.all_groups
  end

end
