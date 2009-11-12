class ProfilesController < ApplicationController

  before_filter :find_position

  def index
    @profiles = @position.profiles
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # POST /profiles
  # POST /profiles.json
  def create
    profile = Profile.add params[:profile]

    respond_to do |format|
      if profile.save
        format.html { redirect_to position_profiles_path(profile.position) }

        format.json {
          render(
            json: {
              profile: {
                id: profile.id,
                name: profile.name,
                show_link: profile_path(profile),
                state: profile.state,
                events: profile.state_events.map do |e|
                  { name: e, url: handle_profile_path(:id => profile.id, :event => e) }
                end
              }
            }, status: :created
          )
        }
      else
        format.html { @profile = profile; render :action => 'new' }
        format.json { render :json => profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /profiles/:id
  def show
    @profile = Profile.find params[:id], :include => [:position, {:logs => :feedback}]
  end

  # POST /profiles/:id/:event
  # POST /profiles/:id/:event.json
  def handle
    profile = Profile.find(params[:id])

    feedback = params[:feedback][:content].strip

    respond_to do |format|
      if profile.trigger params[:event], feedback
        format.json {
          render json: {
            profile: {
              id: profile.id,
              state: profile.state,
              events: profile.state_events.map do |e|
                { name: e, url: handle_profile_path(:id => profile.id, :event => e) }
              end
            }
          }, status: :ok
        }
      else
        format.json { render :nothing => true, :status => :unprocessable_entity }
      end
    end
  end

  private
  def find_position
    @position = if params[:position_id]
                  Position.find params[:position_id]
                elsif params[:profile] and (id = params[:profile][:position_id])
                  # So that raises an exception if position doesn't exist.
                  Position.find id
                end
  end

end
