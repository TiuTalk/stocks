class QuotesImporterWorker
  include Sidekiq::Worker

  def perform(stock_id)
    stock = Stock.find(stock_id)
    QuotesImporter.new(stock).call_async
  rescue AlphaVantage::ApiKey::MissingAvailableKey
    QuotesImporterWorker.perform_in(15.minutes, stock_id)
  rescue AlphaVantage::Client::TooManyRequestsException
    QuotesImporterWorker.perform_in(1.minute, stock_id)
  end
end
