require 'rails_helper'

RSpec.describe AlphaVantage::ApiKey, type: :service do
  describe '.available_api_key' do
    around do |example|
      with_modified_env(ALPHA_VANTAGE_API_KEYS: 'A|B|C') { example.run }
    end

    subject(:key) { described_class.find_available }

    it 'returns the next API key available' do
      current_key = key
      5.times { current_key.use }
      expect(described_class.find_available).to_not eq(current_key)
    end
  end

  describe '#available?' do
    subject(:key) { described_class.new('key') }

    context 'under the rate limit' do
      it 'returns true' do
        expect(key).to be_available
      end
    end

    context 'above the rate limit' do
      before do
        5.times { key.use }
      end

      it 'returns false' do
        expect(key).to_not be_available
      end
    end
  end

  describe '#use' do
    subject(:key) { described_class.new('key') }

    it 'adds one to the rate limit counter' do
      expect do
        key.use
      end.to change { AlphaVantage::Client.rate_limit.count(key.to_s, 1.minute) }.by(1)
    end
  end

  describe '#expire' do
    subject(:key) { described_class.new('key') }

    it 'make the key unavailable' do
      expect { key.expire }.to change { key.available? }.from(true).to(false)
    end
  end
end
