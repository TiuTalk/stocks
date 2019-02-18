class OperationListener
  delegate :wallet, :stock, to: :@operation

  def after_create(operation)
    @operation = operation
    recalculate_holding
  end

  def after_update(operation)
    @operation = operation
    recalculate_holding
  end

  def after_destroy(operation)
    @operation = operation
    recalculate_holding
  end

  private

  def holding
    Holding.find_or_initialize_by(wallet: wallet, stock: stock) do |holding|
      holding.quantity = 0
    end
  end

  def recalculate_holding
    total = purchases_total - sales_total

    if total.zero?
      holding.destroy!
    else
      holding.update!(quantity: total)
    end
  end

  def purchases_total
    wallet.purchases.where(stock: stock).sum(:quantity)
  end

  def sales_total
    wallet.sales.where(stock: stock).sum(:quantity)
  end
end
