class FII < Stock
  # Associations
  belongs_to :stock_exchange, inverse_of: :fiis

  def benchmark
    Stock.find_by(ticker: 'IFIX11') if stock_exchange.b3?
  end
end
