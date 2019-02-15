class QuotesImporter
  def initialize(stock, since: beginning_of_year)
    @stock = stock
    @date_range = since..yesterday
  end

  def call
    return if already_imported?

    Parallel.each(quotes, in_threads: 5) do |quote|
      ActiveRecord::Base.connection_pool.with_connection do
        stock.quotes.find_or_create_by!(quote)
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
  end

  def timeseries
    size = date_range.count > 100 ? 'full' : 'compact'
    AlphaVantage::Client.new.timeseries(stock.alpha_advantage_symbol, outputsize: size)
  end

  def beginning_of_year
    Time.zone.today.beginning_of_year
  end

  def yesterday
    Time.zone.yesterday
  end
end
