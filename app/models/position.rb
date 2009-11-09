class Position < ActiveRecord::Base

  validates_presence_of :name, :category
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000

  belongs_to :category
  has_many :profiles

  before_create :initialize_need

  def state; '0/0' end

  private
  def initialize_need
    self.need = 0
  end
end
