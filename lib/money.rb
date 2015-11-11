require 'money/configuration'
require 'money/validation'

class Money
  class Error < StandardError; end

  extend Configuration
  extend Validation
  include Comparable

  attr_reader :amount, :currency

  def self.conversion_rates(base_currency, rates)
    validate_rate_values(rates.values)

    configure do
      rates_by_currency.merge!(base_currency => rates)
    end
  end

  def initialize(amount, currency)
    @amount = amount.to_r
    @currency = currency
  end

  def inspect
    [format('%.2f', amount), currency].join(' ')
  end

  def convert_to(other_currency)
    return clone if currency == other_currency

    fail(
      Error,
      'Configure conversion rates') unless currency_convertable?(other_currency)

    Money.new(amount * conversion_rate_for(other_currency), other_currency)
  end

  def +(other)
    Money.new(amount + other.convert_to(currency).amount, currency)
  end

  def -(other)
    Money.new(amount - other.convert_to(currency).amount, currency)
  end

  def /(number)
    Money.new(amount / number.to_f, currency)
  end

  def *(number)
    Money.new(amount * number, currency)
  end

  def <=>(other)
    amount <=> other.convert_to(currency).amount
  end

  private

  def currency_convertable?(other_currency)
    !Money.rates_by_currency[currency].empty? ||
      !Money.rates_by_currency[other_currency].empty?
  end

  def conversion_rate_for(other_currency)
    rate = Money.rates_by_currency[currency][other_currency]
    return rate.to_f if rate

    rate = Money.rates_by_currency[other_currency][currency]
    return 1 / rate.to_f if rate

    fail(
      Error, "Conversion rates for #{other_currency} does not exist")
  end
end
