class QuotesImporter
  def initialize(stock, since: last_year)
    @stock = stock
    @date_range = since..yesterday
  end

  def call
    return if already_imported?

    Parallel.each(quotes, in_threads: 5) do |quote|
      ActiveRecord::Base.connection_pool.with_connection do
        record = stock.quotes.find_or_initialize_by(date: quote[:date])
        record.update!(quote)
      end
    end
  end

  def call_async
    return if already_imported?

    quotes.each do |quote|
      QuoteImporterWorker.perform_async(stock.id, quote)
    end
  end

  private

  attr_reader :stock, :date_range

  def already_imported?
    calendar = Business::Calendar.load_cached('weekdays')
    days = calendar.business_days_between(date_range.begin, date_range.end)

    stock.quotes.where(date: date_range).count >= days
  end

  def quotes
    timeseries.select { |quote| date_range.include?(quote[:date]) }
  rescue AlphaVantage::Client::InvalidSymbolException
    @stock.update(enabled: false)
    []
  end

  def timeseries
    size = date_range.count > 100 ? 'full' : 'compact'
    AlphaVantage::Client.new.timeseries(stock.alpha_vantage_symbol, outputsize: size)
  end

  def last_year
    1.year.ago.to_date
  end

  def yesterday
    Time.zone.yesterday
  end
end
