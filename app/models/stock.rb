class Stock < ApplicationRecord
  # Associations
  belongs_to :stock_exchange, inverse_of: :stocks

  # Validations
  validates :name, :ticker, :stock_exchange, presence: true
  validates :ticker, uniqueness: { scope: :stock_exchange_id }
end
