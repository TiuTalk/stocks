class WalletReport < BaseReport
  def initialize(wallet, options = {})
    super(options.symbolize_keys)

    @wallet = wallet
    @operations = wallet.operations.includes(:stock).where(date: date_range).order(date: :asc)
    @stocks = @operations.map(&:stock).uniq
    @quotes = Quote.where(stock: @stocks, date: date_range).order(date: :desc)
  end

  def data
    each_date(cdi: true) do |date, data|
      invested = invested_until_date(date)
      value = value_on_date(date)

      next if value.zero? || invested.zero?

      return_percentage = ((value - invested) / invested).round(2) * 100
      data.merge(invested: invested, value: value, return_percentage: return_percentage)
    end
  end

  private

  attr_reader :wallet, :operations, :stocks, :quotes

  def invested_until_date(date)
    return 0 if date < date_range.begin

    cache([wallet, :invested_until_date, date]) do
      invested_until_date(date - 1.day) + invested_on_date(date)
    end
  end

  def invested_on_date(date)
    purchases_on_date(date).sum(&:total) - sales_on_date(date).sum(&:total)
  end

  def value_on_date(date)
    stocks.map do |stock|
      stock_quantity_on_date(stock, date) * stock_quote_on_date(stock, date).close
    end.sum
  end

  def stock_quantity_on_date(stock, date)
    return 0 if date < date_range.begin

    cache([wallet, :stock_quantity_on_date, stock, date]) do
      stock_quantity_on_date(stock, date - 1.day) +
        stock_purchased_quantity_on_date(stock, date) -
        stock_sold_quantity_on_date(stock, date)
    end
  end

  def stock_quote_on_date(stock, date)
    quotes.find { |quote| quote.stock_id == stock.id && quote.date == date } || NullQuote.new
  end

  def stock_purchased_quantity_on_date(stock, date)
    purchases_on_date(date).select { |operation| operation.stock_id == stock.id }.sum(&:quantity)
  end

  def stock_sold_quantity_on_date(stock, date)
    sales_on_date(date).select { |operation| operation.stock_id == stock.id }.sum(&:quantity)
  end

  def purchases_on_date(date)
    @purchases_on_date ||= {}
    @purchases_on_date[date] ||= purchases.select { |operation| operation.date == date }
  end

  def sales_on_date(date)
    @sales_on_date ||= {}
    @sales_on_date[date] ||= sales.select { |operation| operation.date == date }
  end

  def purchases
    @purchases ||= operations.select { |operation| operation.is_a?(Operations::Purchase) }
  end

  def sales
    @sales ||= operations.select { |operation| operation.is_a?(Operations::Sale) }
  end

  def date_range
    if @operations.present?
      @operations.first.date..Time.zone.yesterday
    else
      super
    end
  end
end
