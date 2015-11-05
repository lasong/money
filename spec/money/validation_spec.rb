require 'spec_helper'

describe Money::Validation do
  describe '.validate_rate_values' do
    it 'should not raise error for numeric values' do
      expect { Money.validate_rate_values([3, 5.4]) }
        .not_to raise_error
    end

    it 'should raise error for numeric values' do
      expect { Money.validate_rate_values(['3', 5.4]) }
        .to raise_error(Money::Error)
    end
  end
end
