class QuoteImporterWorker
  include Sidekiq::Worker

  def perform(stock_id, quote = {})
    stock = Stock.find(stock_id)
    stock.quotes.find_or_create_by!(quote)
  end
end
