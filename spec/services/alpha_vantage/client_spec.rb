require 'rails_helper'

RSpec.describe AlphaVantage::Client, type: :service do
  before do
    key = AlphaVantage::ApiKey.new(ENV['ALPHA_VANTAGE_API_KEYS'].split('|').first)
    allow(AlphaVantage::ApiKey).to receive(:find_available).and_return(key)
  end

  describe '#timeseries', vcr: true do
    subject(:client) { described_class.new }

    context 'with a valid symbol' do
      it 'return recent data about the stock' do
        output = client.timeseries('ITSA4.SAO', outputsize: 'compact')
        expect(output.first).to include(open: 13.29, high: 13.34, low: 13.06, volume: 16_697_600)
      end

      context 'TooManyRequestsException' do
        it 'expire the key and raise error' do
          error_data = { 'Note' => 'Our standard API call frequency is' }
          error = Alphavantage::Error.new(message: 'Invalid API call', data: error_data)
          expect_any_instance_of(Alphavantage::Stock).to receive(:timeseries).and_raise(error)
          expect_any_instance_of(AlphaVantage::ApiKey).to receive(:expire)

          expect do
            client.timeseries('TEST')
          end.to raise_error(Alphavantage::Error)
        end
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
