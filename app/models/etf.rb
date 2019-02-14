class ETF < Stock
  # Associations
  belongs_to :stock_exchange, inverse_of: :etfs
end
