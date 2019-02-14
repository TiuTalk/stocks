class StockExchange < ApplicationRecord
  # Scopes
  scope :b3, -> { find_by(code: 'B3') }
  scope :nyse, -> { find_by(code: 'NYSE') }

  # Validations
  validates :name, :code, :alpha_advantage_code, :country, :timeonze, :open, :close, presence: true
end
