class WalletHistoryCalculatorWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed

  def perform(wallet_id, date)
    wallet = Wallet.find(wallet_id)

    WalletHistoryCalculator.call(wallet, date)
  end
end
