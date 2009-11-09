class ProfileLog < ActiveRecord::Base

  validates_presence_of :action

  belongs_to :profile
  has_one :feedback

end
