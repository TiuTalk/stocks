class QuoteImporterWorker
  include Sidekiq::Worker

  def perform(stock_id, quote = {})
    quote.symbolize_keys!
    stock = Stock.find(stock_id)
    record = stock.quotes.find_or_initialize_by(date: quote[:date])
    record.update!(quote)
  end
end
