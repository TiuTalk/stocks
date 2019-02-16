FactoryBot.define do
  factory :holding do
    wallet
    stock
    quantity { 1 }
  end
end
