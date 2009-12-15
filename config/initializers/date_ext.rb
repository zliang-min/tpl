ActiveSupport::TimeWithZone.class_eval do
  SECONDS_IN_AN_HOUR = (60 * 60).freeze
  SECONDS_IN_A_DAY   = (SECONDS_IN_AN_HOUR * 24).freeze

  def distance
    now = time_zone.now
    dis = (now - self).to_i
    days = dis / SECONDS_IN_A_DAY
    case days
    when 0
      return 'today' if acts_like?(:date)
      hours = dis / SECONDS_IN_AN_HOUR
      case hours
      when 0
        minutes = dis / 60
        minutes <= 5 ? 'just now' : "#{minutes} minutes ago"
      when 1
        'an hour ago'
      else
        "#{hours} hours ago"
      end
    when 1
      'yesterday'
    when 2..6
      "#{days} days ago"
    when 7..32
      n = days / 7
      n == 1 ? "1 week ago" : "#{n} weeks ago"
    when 33..365
      n = now.month - self.month
      n += 12 if n < 1
      n == 1 ? "1 month ago" : n > 11 ? "1 year ago" : "#{n} months ago"
    else
      n = now.year - self.year
      n == 1 ? "1 year ago" : "#{n} years ago"
    end
  end
end
