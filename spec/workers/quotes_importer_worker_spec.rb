require 'rails_helper'

RSpec.describe QuotesImporterWorker, type: :worker do
  let(:stock) { double(Stock) }
  let(:importer) { double(QuotesImporter, call_async: true) }

  context 'with valid stock_id' do
    it 'call QuotesImporter service' do
      expect(Stock).to receive(:find).with('id').and_return(stock)
      expect(QuotesImporter).to receive(:new).with(stock).and_return(importer)
      expect(importer).to receive(:call_async)

      described_class.new.perform('id')
    end
  end
end
