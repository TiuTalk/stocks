class HoldingCalculator
  def initialize(wallet, stock)
    @holding = wallet.holdings.find_or_initialize_by(stock: stock)
    @operations = wallet.operations.where(stock: stock)
  end

  def self.call(wallet, stock)
    new(wallet, stock).call
  end

  def self.call_async(wallet, stock)
    HoldingCalculatorWorker.perform_async(wallet.id, stock.id)
  end

  def call
    if quantity.zero?
      @holding.destroy!
    else
      @holding.update!(attributes)
    end
  end

  private

  def attributes
    { quantity: quantity,
      average_price: average_price,
      accounting_average_price: accounting_average_price,
      invested: invested }
  end

  def quantity
    @operations.purchase_or_sale.sum(:quantity)
  end

  def average_price
    invested / quantity
  end

  def accounting_average_price
    @operations.purchase.sum(:total) / @operations.purchase.sum(:quantity)
  end

  def invested
    @operations.purchase_or_sale.sum(:total)
  end
end
