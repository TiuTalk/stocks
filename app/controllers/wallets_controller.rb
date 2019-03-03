class WalletsController < ApplicationController
  def show
    @wallet = Wallet.find(params[:id])
  end
end
