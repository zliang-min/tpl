class PositionsController < ApplicationController

  # GET /positions
  def index
    @categories = Category.all :order => :name
    @positions  = Position.all :include => [:category, :profiles], :order => 'id DESC'
  end

  # POST /positions
  # POST /positions.json
  def create
    position = Position.new params[:position]
    position.category = Category.find(position.category_id)
    position.creator = current_user

    respond_to do |format|
      if position.save
        format.json  {
          render(
            json: {
              position: {
                id: position.id,
                name: position.name,
                category: position.category.name,
                state: position.state,
                profiles_link: position_profiles_path(position),
                new_profile_link: new_position_profile_path(position)
              }
            },
            status: :created
          )
        }
      else
        format.json  { render :json => position.errors, :status => :unprocessable_entity }
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
