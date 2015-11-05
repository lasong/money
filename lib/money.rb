require 'money/configuration'
require 'money/validation'

class Money
  class Error < StandardError; end

  extend Configuration
  extend Validation

  attr_reader :amount, :currency

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

  def convert_to(other_currency)
    currency_rates = Money.rates_by_currency[currency]

    fail Error, 'Configure conversion rates' unless currency_rates

    fail(
      Error,
      "Conversion rates for #{other_currency} does not exist"
    ) if currency_rates[other_currency].nil?

    @amount *= currency_rates[other_currency]
    @currency = other_currency
    self
  end
end
