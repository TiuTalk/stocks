class WalletPresenter < BasePresenter
  def initialize(wallet)
    super

    @stocks = stocks.includes(:quote)
    @holdings = holdings
  end

  def total_invested
    @holdings.sum(&:invested).to_f
  end

  def total_value
    @stocks.map { |stock| holding_value(stock) }.sum.to_f
  end

  def total_return
    total_value - total_invested
  end

  def total_return_percentage
    return 0 if total_return.zero? || total_invested.zero?

    (total_return / total_invested).round(2)
  end

  def holding_value(stock)
    (stock_quantity(stock) * stock_quote(stock).close).to_f
  end

  private

  def stock_quantity(stock)
    stock_holding(stock).quantity
  end

  def stock_quote(stock)
    @quotes ||= {}
    @quotes[stock.id] ||= stock.quote || NullQuote.new
  end

  def stock_holding(stock)
    holding = @holdings.find { |row| row.stock_id == stock.id }
    holding || NullHolding.new
  end
end
