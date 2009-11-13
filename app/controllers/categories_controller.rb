class CategoriesController < ApplicationController

  def create
    c = Category.new params[:category]

    respond_to do |format|
      if c.save
        format.json  { render :json => c.to_json(:only => [:id, :name]), :status => :created }
      else
        format.json  { render :json => c.errors, :status => :unprocessable_entity }
      end
    end
  end

end
