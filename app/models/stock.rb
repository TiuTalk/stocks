class Stock < ApplicationRecord
  # Associations
  belongs_to :stock_exchange, inverse_of: :stocks
  has_many :quotes, inverse_of: :stock, dependent: :destroy

  # Scopes
  scope :enabled, -> { where(enabled: true) }

  # Validations
  validates :name, :ticker, :stock_exchange, presence: true
  validates :ticker, uniqueness: { scope: :stock_exchange_id }

  # Constants
  BENCHMARK = 'IBOV11'.freeze

  def alpha_advantage_symbol
    "#{ticker}.#{stock_exchange.alpha_advantage_code}"
  end

  def benchmark
    ETF.find_by(ticker: self.class::BENCHMARK)
  end

  def to_chart
    data = quotes.group(:date).order(date: :asc).sum(:close)
    { name: name, data: data }
  end
end
