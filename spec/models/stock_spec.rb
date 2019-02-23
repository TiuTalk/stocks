require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:stocks) }
    it { is_expected.to belong_to(:sector).inverse_of(:stocks).optional }
    it { is_expected.to have_many(:quotes).inverse_of(:stock).dependent(:destroy) }
    it { is_expected.to have_many(:holdings).inverse_of(:stock).dependent(:destroy) }
    it { is_expected.to have_many(:wallets).through(:holdings).inverse_of(:stocks) }
    it { is_expected.to have_many(:operations).inverse_of(:stock) }
    it { is_expected.to have_one(:quote).inverse_of(:stock) }

    describe '#quote' do
      let!(:stock) { create_default(:stock) }
      let!(:quote_a) { create(:quote, date: 3.days.ago) }
      let!(:quote_b) { create(:quote, date: 2.days.ago) }

      it 'returns the latest quote' do
        expect(stock.quote).to eq(quote_b)
      end
    end
  end

  describe 'validations' do
    %i[name ticker stock_exchange].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    context 'ticker' do
      subject { build(:stock) }
      it { is_expected.to validate_uniqueness_of(:ticker).scoped_to(:stock_exchange_id) }
    end
  end

  describe 'scopes' do
    describe '#enabled' do
      it 'returns only stocks that are enabled' do
        stock_a = create(:stock, enabled: true)
        _stock_b = create(:stock, enabled: false)
        create(:holding, stock: stock_a)

        expect(described_class.unscoped.enabled).to eq([stock_a])
      end
    end

    describe '#with_holdings' do
      it 'returns only stocks with holdings' do
        stock_a = create(:stock)
        _stock_b = create(:stock)
        create(:holding, stock: stock_a)

        expect(described_class.unscoped.with_holdings).to eq([stock_a])
      end
    end
  end

  describe '#alpha_vantage_symbol' do
    it 'combines the StockExchange#alpha_vantage_code with the Stock#ticker' do
      stock = build(:stock, :itsa4)
      expect(stock.alpha_vantage_symbol).to eq('ITSA4.SAO')
    end
  end

  describe '#benchmark' do
    context 'B3' do
      let(:b3) { create(:stock_exchange, :b3) }
      let!(:stock) { create(:stock, stock_exchange: b3) }
      let!(:bova11) { create(:etf, :bova11) }

      it 'returns BOVA11' do
        expect(stock.benchmark).to eq(bova11)
      end
    end

    context 'NYSE' do
      it 'returns the benchmark ticker'
    end
  end

  describe '#to_chart' do
    it 'return chart object' do
      stock = create(:stock, name: 'Stock', ticker: 'TICKER')
      3.times { |i| create(:quote, stock: stock, date: (i + 1).days.ago) }

      result = stock.to_chart(1.week.ago..Time.zone.yesterday)
      expect(result[:name]).to eq(stock.ticker)
      expect(result[:data].values.sum).to eq(Quote.sum(:close))
    end
  end
end
