require 'rails_helper'

RSpec.describe QuotesImporter, type: :service do
  before { travel_to(Time.zone.local(2019, 2, 14, 12, 30)) }
  after { travel_back }

  let(:itsa4) { create(:stock, :itsa4) }
  let(:since) { 1.week.ago.to_date }

  describe '#call', vcr: true do
    it 'import quotes since the date' do
      expect do
        described_class.new(itsa4, since: since).call
      end.to change(Quote, :count).by(5)

      Quote.find_each { |c| expect(c.stock).to eq(itsa4) }
    end

    context 'with invalid symbol' do
      let(:exchange) { build(:stock_exchange, alpha_advantage_code: 'TEST') }
      let(:stock) { build(:stock, ticker: 'TEST12', stock_exchange: exchange) }

      it 'dont create quotes' do
        expect do
          described_class.new(stock).call
        end.to_not change(Quote, :count)

        expect(stock.reload).to_not be_enabled
      end
    end
  end

  describe '#call_async', vcr: true do
    it 'enqueue QuoteImporterWorker for each quote' do
      expect do
        described_class.new(itsa4, since: since).call_async
      end.to change(QuoteImporterWorker.jobs, :size).by(5)
    end
  end
end
