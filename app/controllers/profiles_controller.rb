class ProfilesController < ApplicationController

  before_filter :find_position

  def index
    @profiles = (
      params[:show_all].blank? ? @position.not_closed_profiles : @position.profiles
    ).paginate(:page => page, :per_page => per_page)
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # POST /profiles
  # POST /profiles.json
  def create
    profile = Profile.add current_user, params[:profile]

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
                change_state: {
                  text: t(:change_state),
                  href: shift_profile_path(profile)
                }
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
    @profile = Profile.find params[:id], :include => [:position, {:logs => [:operator, :feedback]}]
  end

  # POST /profiles/:id/shift
  # POST /profiles/:id/shift.json
  def shift
    profile = Profile.find(params[:id])

    respond_to do |format|
      if profile.change_state(
        :to => params[:profile][:state],
        :assign_to => params[:profile][:assign_to],
        :by => current_user,
        :feedback => params[:feedback][:content].strip
      )
        format.html { redirect_to :action => :show }
        format.json {
          render :json => profile.to_json(:only => [:id, :state]), status: :ok
        }
      else
        format.html {
          flash[:failure] = '.update_state_failed'
          redirect_to :action => :show
        }
        format.json { render :nothing => true, :status => :unprocessable_entity }
      end
    end
  end

  private
    def find_position
      @position =
        if params[:position_id]
          Position.active.find params[:position_id]
        elsif params[:profile] and (id = params[:profile][:position_id])
          # So that raises an exception if position doesn't exist.
          Position.active.find id
        end
    end

end
