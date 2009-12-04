class ProfileLog < ActiveRecord::Base

  ACTIONS = {
    :new => 'add'.freeze,
    :change_state => 'change_state'.freeze
  }.freeze

  validates_presence_of :action
  validates_presence_of :operator, :on => :create

  belongs_to :profile, :counter_cache => true
  belongs_to :operator, :class_name => 'User', :foreign_key => 'user_id'
  has_one :feedback, :dependent => :destroy

end
