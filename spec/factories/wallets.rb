FactoryBot.define do
  factory :wallet do
    user
    stock_exchange
    name { 'My Porfolio' }
  end
end
