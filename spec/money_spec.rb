require 'spec_helper'

RSpec.describe Money do
  let(:base_currency) { 'EUR' }
  let(:rates) { { 'USD' => 1.09 } }

  context '.conversion_rates' do
    it 'adds rates for currency if it does not exist' do
      described_class.conversion_rates(base_currency, rates)

      expect(Money.rates_by_currency)
        .to eq('EUR' => { 'USD' => 1.09 })
    end

    it 'updates rates for currency if it exists' do
      Money.rates_by_currency = { base_currency => rates }
      rates = { 'USD' => 1.11, 'XAF' => 500.1 }

      described_class.conversion_rates(base_currency, rates)

      expect(Money.rates_by_currency)
        .to eq('EUR' => { 'USD' => 1.11, 'XAF' => 500.1 })
    end
  end

  context '#inspect' do
    it 'returns formated amount with currency' do
      expect(described_class.new(40, 'USD').inspect).to eq '40.00 USD'
    end
  end
end
