require 'spec_helper'

RSpec.describe Money do
  context '#inspect' do
    it 'returns amount with currency' do
      expect(described_class.new(40, 'USD').inspect).to eq '40.00 USD'
    end
  end
end
