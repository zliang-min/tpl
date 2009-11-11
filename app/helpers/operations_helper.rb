module OperationsHelper
  RB_PATTERN = /(\\\\)?\{\{([^\}]+)\}\}/.freeze

  def parse_event event_expression
    BlueCloth.new(
      event_expression.gsub(RB_PATTERN) {
        escaped, exp = $1, $2
        if escaped
          exp
        else
          eval exp
        end
      }
    ).to_html
  end

end
