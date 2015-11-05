require 'spec_helper'

RSpec.describe Money do
  let(:base_currency) { 'EUR' }
  let(:rates) { { 'USD' => 1.09 } }

  context '.conversion_rates' do
    it 'adds rates for currency if it does not exist' do
      Money.conversion_rates(base_currency, rates)

      expect(Money.rates_by_currency)
        .to eq('EUR' => { 'USD' => 1.09 })
    end

    it 'updates rates for currency if it exists' do
      Money.rates_by_currency = { base_currency => rates }
      rates = { 'USD' => 1.11, 'XAF' => 500.1 }

      Money.conversion_rates(base_currency, rates)

      expect(Money.rates_by_currency)
        .to eq('EUR' => { 'USD' => 1.11, 'XAF' => 500.1 })
    end
  end

  context '#inspect' do
    it 'returns formated amount with currency' do
      expect(Money.new(40, 'EUR').inspect).to eq '40.00 EUR'
    end
  end

  context '#convert_to' do
    it 'converts money to another currency' do
      Money.conversion_rates(base_currency, rates)
      money = Money.new(40, 'EUR')

      expect(money.convert_to('USD').inspect).to eq '43.60 USD'
    end

    it 'raises error if currency does not exist in config' do
      Money.conversion_rates(base_currency, rates)
      money = Money.new(40, 'XAF')

      expect { money.convert_to('USD') }.to raise_error(Money::Error)
    end

    it 'raises error if conversion rates for currency does not exist' do
      Money.conversion_rates(base_currency, rates)
      money = Money.new(40, 'EUR')

      expect { money.convert_to('XAF') }.to raise_error(Money::Error)
    end
  end
end
