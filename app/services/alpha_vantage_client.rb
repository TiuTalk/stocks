class AlphaVantageClient
  def available_api_key
    APIKey.api_keys.find(&:available?).to_s
  end

  def timeseries(symbol, params = {})
    stock = client.stock(symbol: symbol)
    params = params.reverse_merge(type: 'daily', outputsize: 'full')
    output = stock.timeseries(params).output
    output['Time Series (Daily)'].map do |day, data|
      { date: Date.parse(day) }.merge(parse_data(data))
    end
  end

  private

  def parse_data(data)
    data.map do |key, value|
      key = key.gsub(/\d\. /, '').to_sym
      value = key == :volume ? value.to_i : value.to_f

      [key, value]
    end.to_h
  end

  def client
    Alphavantage::Client.new(key: available_api_key)
  end

  class APIKey
    def self.api_keys
      keys = ENV.fetch('ALPHA_VANTAGE_API_KEYS', '').split('|')
      keys.map(&APIKey.method(:new))
    end

    def self.rate_limit
      @rate_limit ||= Ratelimit.new(:ALPHA_VANTAGE_API_KEYS, bucket_span: 2.days)
    end

    def initialize(api_key)
      @api_key = api_key
    end

    def to_s
      @api_key
    end

    def available?
      within_bounds?(threshold: 5, interval: 1.minute) &&
        within_bounds?(threshold: 500, interval: 1.day)
    end

    def within_bounds?(bounds)
      self.class.rate_limit.within_bounds?(@api_key, bounds)
    end
  end
end
