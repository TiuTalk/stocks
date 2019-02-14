FactoryBot.define do
  factory :quote do
    stock
    date { 1.day.ago }
    open { rand(1..10.0) }
    close { rand(1..10.0) }
    high { rand(1..10.0) }
    low { rand(1..10.0) }
  end
end
