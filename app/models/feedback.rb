class Feedback < ActiveRecord::Base

  validates_presence_of :content#, :profile_log

  belongs_to :profile_log

end
