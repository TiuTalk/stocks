class StocksController < ApplicationController
  def show
    @stock = Stock.enabled.find_by!(ticker: params[:id])
  end
end
