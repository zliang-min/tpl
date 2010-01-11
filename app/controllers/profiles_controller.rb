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

  # GET /profiles/:id/edit
  def edit
    @profile = Profile.find params[:id], :include => [:position],
      :select => 'profiles.*, positions.name'
  end

  # POST /profiles/:id
  def update
    deleted_resumes = {}
    if resumes = params[:profile][:resumes]
      resumes.each do |id, attrs|
        deleted_resumes[id.to_i] = resumes.delete(id) if attrs[:_delete]
      end
    end

    profile = Profile.find params[:id]
    respond_to do |format|
      if profile.update_attributes params[:profile]
        deleted_resumes.each { |id, attrs| (id == 0 ? profile.cv : profile.resume_collection.find_by_id(id)).destroy }
        # I'm considering should I create a profile log when a profile is updated? Hmmm....
        Operation.create \
          :operator => current_user,
          :event => "_#{current_user.displayname}_ updated " \
                    "profile [#{profile.name}]({{profile_path #{profile.id}}}) " \
                    "at #{I18n.l profile.updated_at, :format => :short}."
                    #"{{Time.zone.parse(#{profile.updated_at.to_s.inspect}).distance}}"
        format.html { redirect_to profile_path(profile) }
      else
        format.html { @profile = profile; render :action => 'edit' }
      end
    end
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
        :feedback => params[:feedback][:content].strip,
        :appointment => (params[:send_appointment] ? params[:appointment] : nil)
      )
        format.html { redirect_to :action => :show }
        format.json {
          render :json => profile.to_json(:only => [:id, :state], :methods => :assignment_info), status: :ok
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
