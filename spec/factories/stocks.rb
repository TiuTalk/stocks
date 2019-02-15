FactoryBot.define do
  factory :stock do
    name { ticker }
    ticker { 'STOCK' + SecureRandom.hex(2).upcase }
    stock_exchange { create(:stock_exchange) }

    trait :itsa4 do
      ticker { 'ITSA4' }
      stock_exchange { StockExchange.b3.presence || create(:stock_exchange, :b3) }
    end
  end

  factory :fii, parent: :stock, class: 'FII'
  factory :etf, parent: :stock, class: 'ETF' do
    trait :ibov11 do
      ticker { 'IBOV11' }
      stock_exchange { StockExchange.b3.presence || create(:stock_exchange, :b3) }
    end

    trait :ifix11 do
      ticker { 'IFIX11' }
      stock_exchange { StockExchange.b3.presence || create(:stock_exchange, :b3) }
    end
  end
end
