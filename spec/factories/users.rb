FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { "user+#{SecureRandom.hex(5).downcase}@example.com" }
    password { 'password!' }
    password_confirmation { password }
  end
end
