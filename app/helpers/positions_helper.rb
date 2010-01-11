module PositionsHelper
  def jd_link(position)
    attachment_link position.jd, :class => 'jd-link'
  end
end
