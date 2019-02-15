class QuotesImporterWorker
  include Sidekiq::Worker

  def perform(stock_id)
    stock = Stock.find(stock_id)

    return unless stock.enabled?

    QuotesImporter.new(stock).call_async
  rescue AlphaVantage::ApiKey::MissingAvailableKey, AlphaVantage::Client::TooManyRequestsException
    QuotesImporterWorker.perform_in(1.minutes, stock_id)
  rescue Alphavantage::Error => exception
    stock.update(enabled: false) if exception.message =~ /Invalid API call/
  end
end
