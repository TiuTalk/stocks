class WalletHistoryCalculator
  def initialize(wallet, date = Time.zone.yesterday)
    @history = wallet.history.find_or_initialize_by(date: date)
    @operations = wallet.operations.includes(:stock).purchase_or_sale.on_or_before(date)
    @stocks = @operations.map(&:stock).uniq
    @quotes = Quote.on_or_before(date).where(stock: @stocks).order(date: :desc)
  end

  def self.call(wallet, date)
    new(wallet, date).call
  end

  def call
    if invested.zero?
      history.destroy!
    else
      history.update!(attributes)
    end
  end

  private

  attr_reader :history, :operations, :stocks, :quotes

  def attributes
    { invested: invested,
      value: value }
  end

  def purchases
    operations.select { |operation| operation.is_a?(Operations::Purchase) }
  end

  def sales
    operations.select { |operation| operation.is_a?(Operations::Sale) }
  end

  def invested
    (purchases.sum(&:total) - sales.sum(&:total)).to_f
  end

  def value
    stocks.map do |stock|
      stock_quantity(stock) * stock_quote(stock).close
    end.sum.to_f
  end

  def stock_quote(stock)
    quotes.find { |quote| quote.stock_id == stock.id } || NullQuote.new
  end

  def stock_quantity(stock)
    stock_purchases(stock).sum(&:quantity) - stock_sales(stock).sum(&:quantity)
  end

  def stock_purchases(stock)
    purchases.select { |operation| operation.stock_id == stock.id }
  end

  def stock_sales(stock)
    sales.select { |operation| operation.stock_id == stock.id }
  end
end
