class Profile < ActiveRecord::Base
  
  PHONE_REGEX = /^\+?[-\d ]+$/.freeze

  attr_protected :state

  validates_presence_of :name, :position_id
  validates_length_of :name, :maximum => 255
  validates_length_of :chinese_name, :maximum => 255, :allow_nil => true
  validates_length_of :education, :maximum => 255, :allow_nil => true
  validates_numericality_of :work_experience, :only_integer => true,
    :allow_nil => true, :greater_than_or_equal_to => 0
  validates_format_of :email, :with => Devise::Models::Validatable::EMAIL_REGEX,
    :allow_blank => true
  validate :validates_birthday_format
  validate :validates_mobile_phone_format

  belongs_to :position
  has_many :logs, :class_name => 'ProfileLog', :order => 'id', :dependent => :destroy
  has_many :feedbacks, :through => :logs

  named_scope :not_closed, :conditions => ['state <> ?', Configuration.group('ProfileStatus').special_state_name_for(:closed)], :order => 'id DESC'

=begin
  has_attached_file :picture
  validates_attachment_content_type :picture,
    :content_type => %r'image/(jpeg|png|gif|bmp)',
    :message => I18n.t('activerecord.errors.messages.profile.picture.invalid_content_type')
=end

  has_attached_file :cv
  validates_attachment_content_type :cv,
    :content_type => [%r'application/(msword|pdf)', %r'text/(plain|html)'],
    :message => I18n.t('activerecord.errors.models.profile.attributes.cv.invalid_content_type')

  before_create :set_initial_state
  before_save   :set_assigned_at

=begin
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

    after_transition :on => :accepted do |profile, _|
      Position.increment_counter :filled, profile.position_id
    end
  end
=end

  # Creates a new profile.
  # @param [User] by_who who did this operation
  # @param [Hash] options
  # @option [Hash] :feedbacks feedback attributes for this operation
  #   @option [String] :content feedback content
  # Other options for +options+ will used as profile attributes.
  # @return [Profile] newly created but not yet saved profile.
  def self.add by_who, options = {}
    feedback = options.delete(:feedbacks)
    feedback[:content].strip! if feedback

    profile = self.new(options)
    log = profile.logs.build :action => ProfileLog::ACTIONS[:new]
    log.operator = by_who
    log.build_feedback :content => feedback[:content] unless feedback[:content].blank?

    profile
  end

  # Changes the state of this profile and save.
  # @param [Hash] options
  # @option [String] :assign_to format: "{email},{user name}"
  # @option [User] :by who did this operation
  # @option [String] :feedback feedback for this operation
  # @option [String] :to the destination state
  # @option [Hash] :appointment
  #   @option [String] :start_time
  #   @option [String] :location
  # @return [Boolean] indicates if successfully save or not.
  def change_state(options={})
    self.assign_to = options[:assign_to] unless options[:assign_to].blank?
    log = logs.build :action => ProfileLog::ACTIONS[:change_state]
    log.operator = options[:by]
    feedback = options[:feedback]
    feedback.strip! if feedback
    log.build_feedback :content => feedback unless feedback.blank?
    self.state = options[:to]
    if save
      if options[:appointment]
        ProfileNotifier.deliver_appointment(log, options[:appointment])
      end
      true
    else
      false
    end
  end

  # Returns the previous profile which belongs to the same position with this.
  # @return [Profile] profile previous to this one.
  def previous_one
    self.class.first \
      :conditions => ['position_id = ? and id < ?', position_id, id],
      :order => 'id DESC'
  end

  # Returns the next profile which belongs to the same position with this.
  # @return [Profile] profile next to this one.
  def next_one
    self.class.first \
      :conditions => ['position_id = ? and id > ?', position_id, id],
      :order => 'id'
  end

  # Returns the user name part of assign_to attribute.
  def assign_to
    (to = read_attribute :assign_to) && to.split(',', 2).last
  end

  # Returns the email part of assign_to attribute.
  def email_of_assigned_user
    (to = read_attribute :assign_to) && to.split(',', 2).first
  end

  def display_name
    if chinese_name.blank?
      name
    else
      "#{name} (#{chinese_name})"
    end
  end

  private
  def validates_birthday_format
    value = birthday_before_type_cast || birthday
    unless value.blank?
      Date.parse(value) rescue errors.add(:birthday, :invalid_date)
    end
  end

  def validates_mobile_phone_format
    value = mobile_phone_before_type_cast || mobile_phone
    unless value.blank?
      unless value =~ PHONE_REGEX and value.gsub(/\D/, '').size > 9
        errors.add(:mobile_phone, :invalid)
      end
    end
  end

  def set_initial_state
    self.state = Configuration.group('ProfileStatus').preferred_statuses.first
    true
  end

  def set_assigned_at
    self.assigned_at = Time.zone.now if changed.include?('assign_to')
    true
  end

end
