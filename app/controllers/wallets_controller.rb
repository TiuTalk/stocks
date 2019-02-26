class WalletsController < ApplicationController
  def show
    @wallet = Wallet.find(params[:id])
    @report = WalletReport.new(@wallet, wallet_report_params.to_unsafe_hash)
  end

  private

  def wallet_report_params
    params.permit(:interval)
  end
end
