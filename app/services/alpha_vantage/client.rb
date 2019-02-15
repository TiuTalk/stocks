module AlphaVantage
  class Client
    def initialize
      @api_key = AlphaVantage::ApiKey.find_available
    end

    def timeseries(symbol, params = {})
      fetch_timeseries(symbol, params)
    rescue TooManyRequestsException
      api_key.expire
      raise
    ensure
      api_key.use
    end

    def self.rate_limit
      @rate_limit ||= Ratelimit.new(:ALPHA_VANTAGE_API_KEYS, bucket_span: 2.days)
    end

    private

    attr_reader :api_key

    def fetch_timeseries(symbol, params)
      stock = client.stock(symbol: symbol)
      data = stock.timeseries(params.reverse_merge(type: 'daily', outputsize: 'full'))
      parse_timeseries(data.output.dig('Time Series (Daily)'))
    end

    def parse_timeseries(timeseries)
      timeseries.map do |day, data|
        { date: Date.parse(day) }.merge(parse_data(data))
      end
    end

    def parse_data(data)
      data.map do |key, value|
        key = key.gsub(/\d\. /, '').to_sym
        value = key == :volume ? value.to_i : value.to_f

        [key, value]
      end.to_h
    end

    def client
      Alphavantage::Client.new(key: api_key.to_s).tap do |client|
        client.verbose = Rails.env.development?
      end
    end

    class TooManyRequestsException < Alphavantage::Error
      def self.===(exception)
        exception.respond_to?(:data) &&
          exception.data.present? &&
          exception.data.dig('Note').to_s.match?(/Our standard API call frequency is/)
      end
    end
  end
end
