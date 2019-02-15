class StocksController < ApplicationController
  def show
    @stock = Stock.enabled.find_by!(ticker: params[:id])
    @chart = [@stock.to_chart, @stock.benchmark&.to_chart].compact
  end
end
