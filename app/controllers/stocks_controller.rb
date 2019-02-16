class StocksController < ApplicationController
  def show
    @stock = Stock.enabled.find_by!(ticker: params[:id])
    @range = 1.year.ago.to_date..Date.yesterday
    @chart = [@stock.to_chart(@range), @stock.benchmark&.to_chart(@range)].compact
  end
end
