FactoryBot.define do
  factory :stock do
    name { 'Random Stock' }
    ticker { 'STOCK' + SecureRandom.hex(2).upcase }
    stock_exchange { create(:stock_exchange) }
  end

  factory :fii, parent: :stock, class: 'FII'
  factory :etf, parent: :stock, class: 'ETF'
end
