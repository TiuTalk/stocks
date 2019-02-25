class HoldingCalculatorWorker
  include Sidekiq::Worker

  def perform(wallet_id, stock_id)
    wallet = Wallet.find(wallet_id)
    stock = Stock.find(stock_id)

    HoldingCalculator.call(wallet, stock)
  end
end
