class ProfileLog < ActiveRecord::Base

  validates_presence_of :action

  belongs_to :profile, :counter_cache => true
  has_one :feedback, :dependent => :destroy

end
