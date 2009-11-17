class Position < ActiveRecord::Base

  validates_presence_of :name, :category
  validates_presence_of :creator, :on => :create
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000
  validates_numericality_of :need, :only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0

  belongs_to :category
  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'
  has_many :profiles, :dependent => :destroy

  before_create :initialize_need

  def state
    if need > 0
      "#{filled}/#{need}" % [filled, need]
    else
      "#{filled}/unlimited"
    end
  end

  private
  def initialize_need
    self.need = 0 unless self.need
  end
end
