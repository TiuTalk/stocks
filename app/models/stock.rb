class Stock < ApplicationRecord
  # Associations
  belongs_to :stock_exchange, inverse_of: :stocks
  has_many :quotes, inverse_of: :stock, dependent: :destroy

  # Validations
  validates :name, :ticker, :stock_exchange, presence: true
  validates :ticker, uniqueness: { scope: :stock_exchange_id }
end
