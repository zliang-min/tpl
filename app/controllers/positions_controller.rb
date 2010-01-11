class PositionsController < ApplicationController

  # GET /positions
  def index
    @categories = Category.all :order => :name
    @positions  = Position.active.with_details.in_creation_order.paginate :page => page, :per_page => per_page
    @position   = Position.new # for position form
  end

  # GET /positions/new
  def new
    @position = Position.new
    render :action => :edit
  end

  # POST /positions
  # POST /positions.json
  def create
    position = Position.new params[:position]
    position.category = Category.find(position.category_id)
    position.creator = current_user

    respond_to do |format|
      if position.save
        format.html { redirect_to :action => :index }
      else
        format.html { @position = position; render :action => :edit }
      end
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.active.find params[:id]
    @categories = Category.all :order => :name
    render :partial => true if request.xhr?
  end

  # POST /positions/1
  # POST /positions/1.json
  def update
    position = Position.active.find params[:id]
    respond_to do |format|
      if position.update_attributes params[:position]
        format.html { redirect_to params[:back_url] }
        format.json do
          render :json => {
            :position => {
              :id       => position.id,
              :name     => position.name,
              :category => position.category.name,
              :state    => position.state,
              :description => position.description
            }
          }
        end
      else
        format.html do 
          @position = position
          render :action => :edit
        end
        format.json  { render :json => position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position = Position.active.find(params[:id])
    @position.close

    respond_to do |format|
      format.html { redirect_to(positions_url) }
      format.json { render :json => {:redirect_to => positions_url} }
    end
  end
end
