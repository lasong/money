require 'rspec'
require 'money'

RSpec.configure do |config|
  config.before(:each) do
    Money.rates_by_currency = Hash.new({})
  end
end
