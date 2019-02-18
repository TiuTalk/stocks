require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  ENV.fetch('ALPHA_VANTAGE_API_KEYS', '').split('|').each do |key|
    config.filter_sensitive_data('<ALPHA_VANTAGE_API_KEY>') { key }
  end
end
