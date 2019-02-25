class QuotesImporterWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed

  def perform(stock_id)
    stock = Stock.find(stock_id)

    return unless stock.enabled?

    QuotesImporter.new(stock).call_async
  rescue AlphaVantage::ApiKey::MissingAvailableKey
    QuotesImporterWorker.perform_in(rand(1..5).minutes, stock_id)
  rescue AlphaVantage::Client::TooManyRequestsException
    QuotesImporterWorker.perform_in(rand(10..30).minutes, stock_id)
  end
end
