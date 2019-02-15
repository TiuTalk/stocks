require 'rails_helper'

RSpec.describe QuotesImporterWorker, type: :worker do
  let(:stock) { double(Stock, enabled?: true) }
  let(:importer) { double(QuotesImporter, call_async: true) }

  before do
    expect(Stock).to receive(:find).with('id').and_return(stock)
    expect(QuotesImporter).to receive(:new).with(stock).and_return(importer)
  end

  context 'with valid stock_id' do
    it 'call QuotesImporter service' do
      expect(importer).to receive(:call_async)
      described_class.new.perform('id')
    end
  end

  context 'AlphaVantage::ApiKey::MissingAvailableKey' do
    it 'reschedule the QuotesImporterWorker' do
      expect(importer).to receive(:call_async).and_raise(AlphaVantage::ApiKey::MissingAvailableKey)

      expect do
        described_class.new.perform('id')
      end.to change(described_class.jobs, :count).by(1)
    end
  end

  context 'AlphaVantage::Client::TooManyRequestsException' do
    it 'reschedule the QuotesImporterWorker' do
      error_data = { 'Note' => 'Our standard API call frequency is' }
      error = Alphavantage::Error.new(message: 'Invalid API call', data: error_data)
      expect(importer).to receive(:call_async).and_raise(error)

      expect do
        described_class.new.perform('id')
      end.to change(described_class.jobs, :count).by(1)
    end
  end
end
