class Profile < ActiveRecord::Base

  validates_presence_of :name, :position
  validates_length_of :name, :maximum => 255

  belongs_to :position
  has_many :logs, :class_name => 'ProfileLog', :order => 'id'
  has_many :feedbacks, :through => :logs

  #accepts_nested_attributes_for :feedbacks

  state_machine :initial => :new do
    after_transition do |profile, trans|
      profile.logs.last.action = trans.event
    end

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
    feedback = options.delete(:feedback)
    feedback.strip! if feedback

    profile = self.new(options)
    log = profile.logs.build :action => 'add'
    log.build_feedback :content => feedback unless feedback.blank?

    profile.save
  end

  def previous_one
    self.class.first :conditions => ['id < ?', id], :order => 'id DESC'
  end

  def next_one
    self.class.first :conditions => ['id > ?', id], :order => 'id'
  end

end
