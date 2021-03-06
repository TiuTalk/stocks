FactoryBot.define do
  factory :stock_exchange do
    name { 'Random Stock Exchange' }
    code { SecureRandom.hex(2) }
    alpha_vantage_code { SecureRandom.hex(3) }
    country { 'BRA' }
    timeonze { 'America/Sao_Paulo' }
    open { '09:00:00' }
    close { '18:00:00' }

    trait :b3 do
      name { 'B3' }
      code { 'B3' }
      alpha_vantage_code { 'SAO' }
      country { 'BRA' }
      timeonze { 'America/Sao_Paulo' }
      open { '09:00:00' }
      close { '18:00:00' }
    end
  end
end
