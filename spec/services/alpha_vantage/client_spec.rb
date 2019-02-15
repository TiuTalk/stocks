require 'rails_helper'

RSpec.describe AlphaVantage::Client, type: :service do
  describe '#timeseries', vcr: true do
    subject(:client) { described_class.new }

    context 'with a valid symbol' do
      it 'return recent data about the stock' do
        output = client.timeseries('ITSA4.SAO', outputsize: 'compact')
        expect(output.first).to include(open: 13.29, high: 13.34, low: 13.06, volume: 16_697_600)
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
