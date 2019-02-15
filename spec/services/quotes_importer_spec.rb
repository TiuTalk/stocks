require 'rails_helper'

RSpec.describe QuotesImporter, type: :service do
  let(:itsa4) { create(:stock, :itsa4) }

  before { travel_to(Time.zone.local(2019, 2, 14, 12, 30)) }
  after { travel_back }

  describe '#call' do
    it 'import quotes since the date', vcr: true do
      expect do
        described_class.new(itsa4, since: 1.week.ago).call
      end.to change(Quote, :count).by(5)

      Quote.find_each { |c| expect(c.stock).to eq(itsa4) }
    end
  end

  describe '#call_async' do
    it 'enqueue QuoteImporterWorker for each quote', vcr: true do
      expect do
        described_class.new(itsa4, since: 1.week.ago).call_async
      end.to change(QuoteImporterWorker.jobs, :size).by(5)
    end
  end
end
