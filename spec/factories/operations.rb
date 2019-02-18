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

  factory :purchase, parent: :operation, class: 'Operations::Purchase'
  factory :sale, parent: :operation, class: 'Operations::Sale'
end
