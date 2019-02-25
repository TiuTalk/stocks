require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:suite) do
    SidekiqUniqueJobs.config.enabled = false
  end

  config.around(sidekiq: :inline) do |example|
    Sidekiq::Testing.inline! { example.run }
  end
end
