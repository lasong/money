class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def inspect
    "#{format('%.2f', amount)} #{currency}"
  end
end
