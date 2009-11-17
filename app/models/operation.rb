class Operation < ActiveRecord::Base

  belongs_to :operator, :class_name => 'User', :foreign_key => 'user_id'

end
