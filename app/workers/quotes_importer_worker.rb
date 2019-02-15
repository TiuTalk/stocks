class QuotesImporterWorker
  include Sidekiq::Worker

  def perform(stock_id)
    stock = Stock.find(stock_id)

    return unless stock.enabled?

    QuotesImporter.new(stock).call_async
  rescue AlphaVantage::ApiKey::MissingAvailableKey
    logger.info('Missing available API key.. rescheduling')
    QuotesImporterWorker.perform_in(rand(1..5).minutes, stock_id)
  rescue AlphaVantage::Client::TooManyRequestsException
    logger.info('Too many requests.. rescheduling')
    QuotesImporterWorker.perform_in(rand(10..30).minutes, stock_id)
  rescue Alphavantage::Error => exceptionlast_year
    stock.update(enabled: false) if exception.message =~ /Invalid API call/
  end
end
