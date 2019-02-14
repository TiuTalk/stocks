class FII < Stock
  # Associations
  belongs_to :stock_exchange, inverse_of: :fiis
end
