class Position < ActiveRecord::Base

  validates_presence_of :name, :category
  validates_presence_of :creator, :on => :create
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000, :allow_nil => true
  validates_numericality_of :need, :only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0

  belongs_to :category
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  has_many :profiles, :dependent => :destroy, :order => 'id DESC'
  has_many :not_closed_profiles, :class_name => 'Profile',
    :conditions => ['state <> ?', Configuration.group('ProfileStatus').special_state_name_for(:closed)], :order => 'id DESC'

  has_attached_file :jd
  validates_attachment_content_type :jd,
    :content_type => [%r'application/(msword|pdf)', %r'application/vnd.openxmlformats-officedocument.wordprocessingml.document', %r'text/(plain|html)'],
    :message => I18n.t('activerecord.errors.models.position.attributes.jd.invalid_content_type')

  before_create :initialize_defaults

  # ---- named scopes -----
  named_scope :active, :conditions => ['closed <> ?', [true]]
  named_scope :with_details, :include => [:category, :not_closed_profiles]
  named_scope :in_creation_order, :order => 'id DESC'
  # ---- named scopes -----

  def state
    if need > 0
      "#{filled}/#{need}" % [filled, need]
    else
      "#{filled}/unlimited"
    end
  end

  def description=(desc)
    desc.strip!
    desc = nil if desc.blank?
    write_attribute :description, desc
  end

  def close
    self.closed = true
    save
  end

  def close!
    self.closed = true
    save!
  end

  private
  def initialize_defaults
    self.need = 0 unless self.need
    self.closed = false
    true # this is important, because last expression is false!
  end
end
