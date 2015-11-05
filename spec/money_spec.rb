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
    before { Money.conversion_rates(base_currency, rates) }

    it 'converts money from base currency to another currency' do
      money = Money.new(40, 'EUR')

      expect(money.convert_to('USD').inspect).to eq '43.60 USD'
    end

    it 'converts money from another currency to base currency' do
      money = Money.new(40, 'USD')

      expect(money.convert_to('EUR').inspect).to eq '36.70 EUR'
    end

    it 'raises error if currency does not exist in config' do
      money = Money.new(40, 'XAF')

      expect { money.convert_to('USD') }.to raise_error(Money::Error)
    end

    it 'raises error if conversion rates for currency does not exist' do
      money = Money.new(40, 'EUR')

      expect { money.convert_to('XAF') }.to raise_error(Money::Error)
    end
  end

  describe 'Arithmetics' do
    before { Money.conversion_rates(base_currency, rates) }

    context '#+' do
      it 'sums two money objects with the same currency' do
        money = Money.new(21, 'EUR') + Money.new(12, 'EUR')

        expect(money.amount).to eq 33.0
        expect(money.currency).to eq 'EUR'
      end

      it 'sums two money objects with different currencies' do
        money = Money.new(21, 'EUR') + Money.new(12, 'USD')

        expect(money.amount).to be_within(0.001).of(32.01)
        expect(money.currency).to eq 'EUR'
      end
    end

    context '#-' do
      it 'sums two money objects with the same currency' do
        money = Money.new(21, 'USD') - Money.new(12, 'USD')

        expect(money.amount).to eq 9.0
        expect(money.currency).to eq 'USD'
      end

      it 'sums two money objects with different currencies' do
        money = Money.new(21, 'USD') - Money.new(12, 'EUR')

        expect(money.amount).to be_within(0.001).of(7.92)
        expect(money.currency).to eq 'USD'
      end
    end

    context '#/' do
      it 'divides the money amount by a given number' do
        money = Money.new(21, 'EUR') / 7

        expect(money.amount).to eq 3.0
        expect(money.currency).to eq 'EUR'
      end
    end

    context '#*' do
      it 'multiplies the money amount by a given number' do
        money = Money.new(21, 'EUR') * 2

        expect(money.amount).to eq 42.0
        expect(money.currency).to eq 'EUR'
      end
    end
  end

  describe 'Comparison' do
    before { Money.conversion_rates(base_currency, rates) }

    context '#==' do
      it 'returns true for same currencies and monetary amounts' do
        money = Money.new(20, 'EUR')

        expect(money == Money.new(20, 'EUR')).to be_truthy
      end

      it 'returns true for different currencies and same converted amounts' do
        money_eur = Money.new(20, 'EUR')

        expect(money_eur == money_eur.convert_to('USD')).to be_truthy
      end

      it 'is equal if monetary amounts agree up to the cents' do
        expect(Money.new(20, 'EUR') == Money.new(20.01, 'EUR')).to be_truthy
      end

      it 'returns false for objects with different monetary amounts' do
        expect(Money.new(20, 'EUR') == Money.new(30, 'EUR')).to be_falsy
      end

      it 'returns false for objects with different currencies' do
        expect(Money.new(20, 'EUR') == Money.new(20, 'USD')).to be_falsy
      end
    end

    context '#>' do
      it 'return true for monetary amount greater than the other' do
        expect(Money.new(20, 'EUR') > Money.new(10.01, 'EUR')).to be_truthy
      end

      it 'returns true for the case of different currencies' do
        expect(Money.new(20, 'EUR') > Money.new(21.01, 'USD')).to be_truthy
      end

      it 'returns false for monetary amount less than the other' do
        expect(Money.new(20, 'EUR') > Money.new(25.01, 'USD')).to be_falsy
      end
    end

    context '#<' do
      it 'returns true for monetary amount less than the other' do
        expect(Money.new(20, 'EUR') < Money.new(20.11, 'EUR')).to be_truthy
      end

      it 'returns false for the case of different currencies' do
        expect(Money.new(20, 'EUR') < Money.new(24.01, 'USD')).to be_truthy
      end

      it 'return false for monetary amount greater than the other' do
        expect(Money.new(21, 'EUR') < Money.new(20, 'EUR')).to be_falsy
      end
    end
  end
end
