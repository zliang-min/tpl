class Position < ActiveRecord::Base

  validates_presence_of :name, :category
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000
  validates_numericality_of :need, :only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0

  belongs_to :category
  has_many :profiles, :dependent => :destroy

  before_create :initialize_need

  def state; '%d/%d' % [filled, need] end

  # For operation record
  def event which
    position = "[#{name}]({{position_profiles_path #{id}}})(#{category.name})"
    case which
    when :created
      %Q^A new position #{position} has been created at #{I18n.l created_at, :format => :short}.^
    when :updated
      %Q^Position #{position} has been updated at #{I18n.l updated_at, :format => :short}.^
    end
  end

  private
  def initialize_need
    self.need = 0 unless self.need
  end
end
