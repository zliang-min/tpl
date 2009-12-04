class Profile < ActiveRecord::Base

  attr_protected :state

  validates_presence_of :name, :position_id
  validates_length_of :name, :maximum => 255
  validates_length_of :education, :maximum => 255, :allow_nil => true
  validates_numericality_of :work_experience, :only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0
  validate :birthday_should_be_a_valid_date

  belongs_to :position
  has_many :logs, :class_name => 'ProfileLog', :order => 'id', :dependent => :destroy
  has_many :feedbacks, :through => :logs

=begin
  has_attached_file :picture
  validates_attachment_content_type :picture,
    :content_type => %r'image/(jpeg|png|gif|bmp)',
    :message => I18n.t('activerecord.errors.messages.profile.picture.invalid_content_type')

  has_attached_file :cv
  validates_attachment_content_type :cv,
    :content_type => [%r'application/(msword|pdf)', %r'text/(plain|html)'],
    :message => I18n.t('activerecord.errors.messages.profile.cv.invalid_content_type')
=end

  before_create :set_initial_state

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

  def self.add by_who, options = {}
    feedback = options.delete(:feedbacks)
    feedback[:content].strip! if feedback

    profile = self.new(options)
    log = profile.logs.build :action => ProfileLog::ACTIONS[:new]
    log.operator = by_who
    log.build_feedback :content => feedback[:content] unless feedback[:content].blank?

    profile
  end

  def change_state(options={})
    self.assign_to = options[:assign_to] unless options[:assign_to].blank?
    log = logs.build :action => ProfileLog::ACTIONS[:change_state]
    log.operator = options[:by]
    feedback = options[:feedback]
    feedback.strip! if feedback
    log.build_feedback :content => feedback unless feedback.blank?
    self.state = options[:to]
    save
  end

  def previous_one
    self.class.first :conditions => ['id < ?', id], :order => 'id DESC'
  end

  def next_one
    self.class.first :conditions => ['id > ?', id], :order => 'id'
  end

  private
  def birthday_should_be_a_valid_date
    value = birthday_before_type_cast || birthday
    unless value.blank?
      Date.parse(value) rescue errors.add(:birthday, :invalid_date)
    end
  end

  def set_initial_state
    self.state = Configuration.group('ProfileStatus').preferred_statuses.first
  end

end
