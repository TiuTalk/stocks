class StocksController < ApplicationController
  def show
    @stock = Stock.enabled.find_by!(ticker: params[:id])

    @chart = [
      stock_quotes_to_chart(@stock),
      stock_quotes_to_chart(@stock.benchmark)
    ].compact
  end

  private

  def stock_quotes_to_chart(stock)
    return if stock.blank?

    { name: stock.name, data: stock_quotes_data(stock) }
  end

  def stock_quotes_data(stock)
    calendar = Business::Calendar.load_cached('weekdays')
    quotes = stock.quotes.group(:date).order(date: :asc).sum(:close)

    return quotes

    quotes.map do |day, quote|
      previous_day = calendar.previous_business_day(day)
      previous_quote = quotes.fetch(previous_day, nil)

      if previous_quote
        [day, (((quote - previous_quote) / previous_quote) * 100).round(2)]
      else
        [day, 0]
      end
    end
  end
end
