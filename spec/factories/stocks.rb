FactoryBot.define do
  factory :stock do
    name { 'Random Stock' }
    ticker { 'STOCK' + SecureRandom.hex(2).upcase }
    stock_exchange { create(:stock_exchange) }

    trait :itsa4 do
      name { 'Itaú SA' }
      ticker { 'ITSA4' }
      stock_exchange { StockExchange.b3.presence || create(:stock_exchange, :b3) }
    end
  end

  factory :fii, parent: :stock, class: 'FII'
  factory :etf, parent: :stock, class: 'ETF'
end
