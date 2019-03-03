FactoryBot.define do
  factory :operation do
    wallet
    stock
    quantity { rand(1..100) }
    price { rand(1..10.0) }
    taxes { 1.49 }
    date { 1.day.ago }
  end

  factory :purchase, parent: :operation, class: 'Operations::Purchase'
  factory :sale, parent: :operation, class: 'Operations::Sale'
end
