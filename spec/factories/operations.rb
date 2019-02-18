FactoryBot.define do
  factory :operation do
    wallet
    stock
    quantity { 1 }
    price { rand(1..10.0) }
    taxes { 1.49 }
    total { price + taxes }
    date { 1.day.ago }
  end

  factory :buy, parent: :operation, class: 'Operations::Buy'
  factory :sell, parent: :operation, class: 'Operations::Sell'
end
