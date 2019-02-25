class WalletHistoryCalculatorWorker
  include Sidekiq::Worker

  def perform(wallet_id, date)
    wallet = Wallet.find(wallet_id)

    WalletHistoryCalculator.call(wallet, date)
  end
end
