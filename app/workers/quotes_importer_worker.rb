class QuotesImporterWorker
  include Sidekiq::Worker

  def perform(stock_id)
    stock = Stock.find(stock_id)
    QuotesImporter.new(stock).call_async
  end
end
