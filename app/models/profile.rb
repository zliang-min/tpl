class Profile < ActiveRecord::Base

  validates_presence_of :name, :position_id
  validates_length_of :name, :maximum => 255

  belongs_to :position
  has_many :logs, :class_name => 'ProfileLog', :order => 'id', :dependent => :destroy
  has_many :feedbacks, :through => :logs

  has_attached_file :picture
  validates_attachment_content_type :picture,
    :content_type => %r'image/(jpeg|png|gif|bmp)',
    :message => I18n.t('profile.errors.picture.content_type')

  has_attached_file :cv
  validates_attachment_content_type :cv,
    :content_type => [%r'application/(msword|pdf)', %r'text/(plain|html)'],
    :message => I18n.t('profile.errors.cv.content_type')

  before_update :memorize_changes

  state_machine :initial => :new do
    # *WARNING* Don't use 'any' nor 'all' in the _from_ part of a transition. Because state_events cannot see that kinds of events.
    event :reject do
      transition [:new, :interview, :pending] => :rejected
    end

    event :interview do
      transition :new => :interview
    end

    event :pend do
      transition :interview => :pending
    end

    event :satisfy do
      transition [:pending, :interview] => :satisfied
    end

    event :offer do
      transition :satisfied => :offered
    end

    event :refused do
      transition :offered => :refused
    end

    event :accepted do
      transition :offered => :accepted
    end
  end

  def self.add options = {}
    feedback = options.delete(:feedbacks)
    feedback[:content].strip! if feedback

    profile = self.new(options)
    log = profile.logs.build :action => 'add'
    log.build_feedback :content => feedback[:content] unless feedback[:content].blank?

    profile
  end

  def trigger event, feedback = nil
    log = logs.build :action => event
    feedback.strip! if feedback
    log.build_feedback :content => feedback unless feedback.blank?
    fire_events event.to_sym
  end

  def previous_one
    self.class.first :conditions => ['id < ?', id], :order => 'id DESC'
  end

  def next_one
    self.class.first :conditions => ['id > ?', id], :order => 'id'
  end

  # For operation record
  def event which
    profile = "[#{name}]({{profile_path #{id}}})"
    case which
    when :created
      %Q^A new profile #{profile} has been added to [#{position.name}]({{position_profiles_path #{position.id}}})(#{position.category.name}) at #{I18n.l created_at, :format => :short}.^
    when :updated
      if @changes_before_update.has_key?('state')
        %Q^Profile #{profile} has been #{state} at #{I18n.l(updated_at, :format => :short)}.^
      else
        %Q^Profile #{profile} has been updated at #{I18n.l(updated_at, :format => :short)}.^
      end
    end
  end

  private
  def memorize_changes
    @changes_before_update = changes
  end

end
