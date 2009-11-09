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
    category = Category.find_by_id params[:position].delete(:category)
    position = Position.new params[:position]
    position.category = category

    respond_to do |format|
      if position.save
        format.json  {
          render(
            json: {
              position: position.attributes.merge(
                category: position.category.attributes,
                state: position.state,
                profiles_link: position_profiles_path(position)
              )
            },
            #json: position.to_json(include: :category, methods: :state),
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
