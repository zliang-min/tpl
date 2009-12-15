class Category < ActiveRecord::Base

  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :name
  validates_length_of :description, :maximum => 1000, :allow_nil => true

  has_many :positions, :dependent => :destroy

end
