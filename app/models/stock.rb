class Stock < ApplicationRecord
  # Associations
  belongs_to :stock_exchange, inverse_of: :stocks
  belongs_to :sector, inverse_of: :stocks, optional: true
  has_many :quotes, inverse_of: :stock, dependent: :destroy
  has_many :holdings, inverse_of: :stock, dependent: :destroy
  has_many :wallets, through: :holdings, inverse_of: :stocks
  has_many :operations, inverse_of: :stock, dependent: :destroy
  has_one :quote, -> { order(date: :desc) }, inverse_of: :stock

  # Scopes
  scope :enabled, -> { where(enabled: true) }

  # Validations
  validates :name, :ticker, :stock_exchange, presence: true
  validates :ticker, uniqueness: { scope: :stock_exchange_id }

  # Constants
  BENCHMARK = 'BOVA11'.freeze

  def alpha_vantage_symbol
    "#{ticker}.#{stock_exchange.alpha_vantage_code}"
  end

  def benchmark
    ETF.find_by(ticker: self.class::BENCHMARK)
  end

  def to_chart(range)
    data = quotes.where(date: range).group(:date)
    { name: ticker, data: data.sum(:close), color: color }
  end

  def color
    hex = Digest::MD5.hexdigest(ticker)[0..5]
    "##{hex}"
  end
end
