require 'money/configuration'
require 'money/validation'

class Money
  class Error < StandardError; end

  extend Configuration
  extend Validation

  attr_accessor :amount, :currency

  def self.conversion_rates(base_currency, rates)
    validate_rate_values(rates.values)

    configure do
      rates_by_currency[base_currency] ||= {}
      rates_by_currency[base_currency].merge!(rates)
    end
  end

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def inspect
    [format('%.2f', amount), currency].join(' ')
  end
end
