require 'sidekiq/testing'

RSpec.configure do |config|
  config.around(sidekiq: :inline) do |example|
    Sidekiq::Testing.inline! { example.run }
  end
end
