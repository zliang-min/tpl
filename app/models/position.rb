class Position < ActiveRecord::Base

  validates_presence_of :name, :category
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000

  belongs_to :category

end
