class OperationListener
  def after_create(operation)
    recalculate_holding(operation)
    recalculate_wallet_history(operation)
  end

  def after_update(operation)
    recalculate_holding(operation)
    recalculate_wallet_history(operation)
  end

  def after_destroy(operation)
    recalculate_holding(operation)
    recalculate_wallet_history(operation)
  end

  private

  def recalculate_holding(operation)
    HoldingCalculator.call_async(operation.wallet, operation.stock)
  end

  def recalculate_wallet_history(operation)
    operation.date.upto(Time.zone.today) do |date|
      WalletHistoryCalculator.call_async(operation.wallet, date)
    end
  end
end
