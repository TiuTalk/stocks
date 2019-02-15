module AlphaVantage
  class ApiKey
    RATE_LIMITS = {
      4 => 1.minute,
      400 => 1.day
    }.freeze

    delegate :rate_limit, to: AlphaVantage::Client

    def self.find_available
      api_keys.find(&:available?) || raise(MissingAvailableKey)
    end

    def self.api_keys
      ENV.fetch('ALPHA_VANTAGE_API_KEYS', '').split('|').map { |key| new(key) }
    end

    def initialize(api_key)
      @api_key = api_key
    end

    def to_s
      @api_key
    end

    def available?
      RATE_LIMITS.all? do |threshold, interval|
        within_bounds?(threshold: threshold, interval: interval)
      end
    end

    def use
      rate_limit.add(to_s)
    end

    def expire
      Rails.logger.warn("Expiring ALPHA_VANTAGE_API_KEY key #{self}")
      rate_limit.add(to_s, RATE_LIMITS.keys.max / 2)
    end

    def within_bounds?(bounds)
      rate_limit.within_bounds?(@api_key, bounds)
    end
  end

  class MissingAvailableKey < StandardError
  end
end
