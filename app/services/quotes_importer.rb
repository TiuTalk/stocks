class QuotesImporter
  def initialize(stock, since:)
    @stock = stock
    @since = since
  end

  def call
    Parallel.each(quotes, in_threads: 5) do |quote|
      ActiveRecord::Base.connection_pool.with_connection do
        @stock.quotes.find_or_create_by!(quote.except(:volume))
      end
    end
  end

  def call_async
    quotes.each do |quote|
      QuoteImporterWorker.perform_async(@stock.id, quote.except(:volume))
    end
  end

  private

  def quotes
    AlphaVantageClient.new.timeseries(@stock.alpha_advantage_symbol).select do |quote|
      quote[:date].between?(@since, Time.zone.today)
    end
  end
end
