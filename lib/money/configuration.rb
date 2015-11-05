class Money
  module Configuration
    attr_writer :rates_by_currency

    def configure
      yield self
    end

    def rates_by_currency
      @rates_by_currency ||= {}
    end
  end
end
