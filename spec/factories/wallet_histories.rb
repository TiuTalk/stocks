FactoryBot.define do
  factory :wallet_history do
    wallet
    date { rand(1..100).days.ago }
    invested { rand(1..100.0) }
    value { rand(1..100.0) }
  end
end
