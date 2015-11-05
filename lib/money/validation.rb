class Money
  module Validation
    def validate_rate_values(values)
      fail Money::Error, 'Rates must be numeric' if values.any? do |value|
                                                      !value.is_a?(Numeric)
                                                    end
    end
  end
end
