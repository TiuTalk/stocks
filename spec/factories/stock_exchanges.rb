FactoryBot.define do
  factory :stock_exchange do
    name { 'Random Stock Exchange' }
    code { SecureRandom.hex(2) }
    alpha_advantage_code { SecureRandom.hex(3) }
    country { 'BRA' }
    timeonze { 'America/Sao_Paulo' }
    open { '09:00:00' }
    close { '18:00:00' }

    trait :b3 do
      name { 'B3' }
      code { 'B3' }
      alpha_advantage_code { 'SAO' }
      country { 'BRA' }
      timeonze { 'America/Sao_Paulo' }
      open { '09:00:00' }
      close { '18:00:00' }
    end

    trait :nyse do
      name { 'New York Stock Exchange' }
      code { 'NYSE' }
      alpha_advantage_code { 'NYSE' }
      country { 'USA' }
      timeonze { 'America/New_York' }
    end
  end
end
