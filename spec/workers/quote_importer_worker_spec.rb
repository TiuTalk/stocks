require 'rails_helper'

RSpec.describe QuoteImporterWorker, type: :worker do
  let(:quote) { { date: 1.day.ago, low: 9.0, high: 15.0, open: 1, close: 2, volume: 3 } }

  context 'with valid stock_id' do
    let(:stock) { create(:stock) }

    it 'creates the quote' do
      expect do
        described_class.new.perform(stock.id, quote.stringify_keys)
      end.to change(Quote, :count).by(1)

      quote = Quote.last
      expect(quote.stock).to eq(stock)
      expect(quote.low).to eq(9.0)
      expect(quote.high).to eq(15.0)
    end
  end

  context 'with invalid stock_id' do
    it 'raise error' do
      expect do
        described_class.new.perform('invalid', quote.stringify_keys)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
