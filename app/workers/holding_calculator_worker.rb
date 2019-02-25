class HoldingCalculatorWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed

  def perform(wallet_id, stock_id)
    wallet = Wallet.find(wallet_id)
    stock = Stock.find(stock_id)

    HoldingCalculator.call(wallet, stock)
  end
end
