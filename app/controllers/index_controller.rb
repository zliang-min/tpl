class IndexController < ApplicationController

  def index
    #@categories = Category.all(:select => 'name', :order => 'name')
    @operations = Operation.all(:order => 'id DESC', :limit => 20)

    flash.discard # remove login messages
  end

end
