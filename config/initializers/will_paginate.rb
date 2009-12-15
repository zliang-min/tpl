# Global per page
class << ActiveRecord::Base
  def per_page
    Configuration::Application['per_page']
  end
end
