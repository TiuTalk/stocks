require 'rails_helper'

RSpec.describe AlphaVantageClient, type: :service do
  describe '#available_api_key' do
    around do |example|
      with_modified_env(ALPHA_VANTAGE_API_KEYS: 'A|B|C') { example.run }
    end

    subject(:client) { described_class.new }

    it 'returns an API key that has not being used too much' do
      expect(subject.available_api_key).to eq('A')
    end

    it 'returns the next API key available' do
      expect do
        5.times { described_class::APIKey.rate_limit.add('A') }
      end.to change { subject.available_api_key }.from('A').to('B')
    end
  end

  describe '#timeseries', vcr: true do
    subject(:client) { described_class.new }

    context 'with a valid symbol' do
      it 'return recent data about the stock' do
        output = client.timeseries('ITSA4.SAO', outputsize: 'compact')
        expect(output.first).to include(open: 13.09, high: 13.17, low: 12.88, volume: 15_550_100)
      end
    end

    context 'with invalid symbol' do
      it 'raise error' do
        expect do
          client.timeseries('INVALID', outputsize: 'compact')
        end.to raise_error(Alphavantage::Error, /Invalid API call/)
      end
    end
  end
end
