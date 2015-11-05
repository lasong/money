require 'spec_helper'

describe Money::Configuration do
  describe '.configure' do
    it 'should have default conversion_rates_by_currency' do
      Money.configure do |config|
        expect(config.rates_by_currency).to eq({})
      end
    end
  end
end
