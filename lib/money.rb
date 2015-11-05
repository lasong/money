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
      rates_by_currency.merge!(base_currency => rates)
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
    fail(
      Error,
      'Configure conversion rates') unless currency_convertable?(other_currency)

    @amount *= amount_conversion_rate(other_currency)
    @currency = other_currency
    self
  end

  private

  def currency_convertable?(other_currency)
    !Money.rates_by_currency[currency].empty? ||
      !Money.rates_by_currency[other_currency].empty?
  end

  def amount_conversion_rate(other_currency)
    rate = Money.rates_by_currency[currency][other_currency]
    return rate if rate

    rate = Money.rates_by_currency[other_currency][currency]
    return 1.0 / rate if rate

    fail(
      Error, "Conversion rates for #{other_currency} does not exist")
  end
end
