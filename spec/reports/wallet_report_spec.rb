require 'rails_helper'

RSpec.describe WalletReport, type: :report do
  let!(:wallet) { create_default(:wallet) }

  let(:stock_a) { create(:stock) }
  let(:stock_b) { create(:stock, stock_exchange: stock_a.stock_exchange) }
  let(:yesterday) { Time.zone.yesterday }

  before do
    create(:purchase, stock: stock_a, date: 1.month.ago)
    create(:purchase, stock: stock_a, date: 1.week.ago)
    create(:purchase, stock: stock_a, date: 1.day.ago)
    create(:purchase, stock: stock_b, date: 3.days.ago)

    1.month.ago.to_date.upto(yesterday) do |date|
      create(:quote, stock: stock_a, date: date)
      create(:quote, stock: stock_b, date: date)
    end
  end

  subject(:report) { described_class.new(wallet, interval: :weekly) }

  describe '#data' do
    it 'include an item for each week between first purchase and yesterday' do
      data = report.data
      expect(data.count).to eq(5)
    end
  end

  describe '#date_range' do
    it 'override the BaseReport#date_range' do
      expect(report.send(:date_range)).to eq(1.month.ago.to_date..Time.zone.yesterday)
    end
  end
end
