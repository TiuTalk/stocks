class OperationListener
  def after_create(operation)
    recalculate_holding(operation)
  end

  def after_update(operation)
    recalculate_holding(operation)
  end

  def after_destroy(operation)
    recalculate_holding(operation)
  end

  private

  def recalculate_holding(operation)
    HoldingCalculator.call_async(operation.wallet, operation.stock)
  end
end
