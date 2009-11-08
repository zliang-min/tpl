class PositionsController < ApplicationController

  # GET /positions
  def index
    @categories = Category.all :order => :name
    @positions  = Position.all :include => :category
  end

  # GET /positions/1
  def show
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(params[:position])

    respond_to do |format|
      if @position.save
        flash[:notice] = 'Position was successfully created.'
        format.html { redirect_to(@position) }
        format.json  { render :json => @position, :status => :created, :location => @position }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to(positions_url) }
      format.json  { head :ok }
    end
  end
end
