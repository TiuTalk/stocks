class HoldingCalculator
  def initialize(wallet, stock)
    @holding = wallet.holdings.find_or_initialize_by(stock: stock)
    @operations = wallet.operations.purchase_or_sale.where(stock: stock)
  end

  def self.call(wallet, stock)
    new(wallet, stock).call
  end

  def call
    if quantity.zero?
      holding.destroy!
    else
      holding.update!(attributes)
    end
  end

  private

  attr_reader :holding, :operations

  def attributes
    { quantity: quantity,
      average_price: average_price,
      accounting_average_price: accounting_average_price,
      invested: invested }
  end

  def quantity
    purchases.sum(&:quantity) - sales.sum(&:quantity)
  end

  def purchases
    operations.select { |operation| operation.is_a?(Operations::Purchase) }
  end

  def sales
    operations.select { |operation| operation.is_a?(Operations::Sale) }
  end

  def average_price
    invested / quantity
  end

  def accounting_average_price
    purchases.sum(&:total) / purchases.sum(&:quantity)
  end

  def invested
    purchases.sum(&:total) - sales.sum(&:total)
  end
end
