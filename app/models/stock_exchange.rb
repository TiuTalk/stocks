class StockExchange < ApplicationRecord
  # Associations
  has_many :stocks, inverse_of: :stock_exchange, dependent: :destroy

  # Scopes
  scope :b3, -> { find_by(code: 'B3') }
  scope :nyse, -> { find_by(code: 'NYSE') }

  # Validations
  validates :name, :code, :alpha_advantage_code, :country, :timeonze, :open, :close, presence: true
end
