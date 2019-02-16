class StockExchange < ApplicationRecord
  # Associations
  has_many :sectors, inverse_of: :stock_exchange, dependent: :destroy
  has_many :stocks, inverse_of: :stock_exchange, dependent: :destroy
  has_many :fiis, class_name: 'FII', inverse_of: :stock_exchange, dependent: :destroy
  has_many :etfs, class_name: 'ETF', inverse_of: :stock_exchange, dependent: :destroy
  has_many :wallets, inverse_of: :stock_exchange, dependent: :destroy

  # Scopes
  scope :b3, -> { find_by(code: 'B3') }

  # Validations
  validates :name, :code, :alpha_vantage_code, :country, :timeonze, :open, :close, presence: true
end
