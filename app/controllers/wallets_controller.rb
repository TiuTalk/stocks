class WalletsController < ApplicationController
  def show
    @wallet = Wallet.find(params[:id])
    @report = WalletReport.new(@wallet)
  end
end
