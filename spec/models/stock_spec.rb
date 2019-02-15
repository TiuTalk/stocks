require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:stocks) }
    it { is_expected.to have_many(:quotes).inverse_of(:stock).dependent(:destroy) }
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

  describe '#alpha_advantage_symbol' do
    it 'combines the StockExchange#alpha_advantage_code with the Stock#ticker' do
      stock = build(:stock, :itsa4)
      expect(stock.alpha_advantage_symbol).to eq('ITSA4.SAO')
    end
  end

  describe '#benchmark' do
    context 'B3' do
      let(:b3) { create(:stock_exchange, :b3) }
      let!(:stock) { create(:stock, stock_exchange: b3) }
      let!(:ibov11) { create(:etf, :ibov11) }

      it 'returns IBOV11' do
        expect(stock.benchmark).to eq(ibov11)
      end
    end

    context 'NYSE' do
      it 'returns the benchmark ticker'
    end
  end

  describe '#to_chart' do
    it 'return chart object' do
      stock = create(:stock)
      3.times { |i| create(:quote, stock: stock, date: (i + 1).days.ago) }

      result = stock.to_chart
      expect(result[:name]).to eq(stock.name)
      expect(result[:data].values.sum).to eq(Quote.sum(:close))
    end
  end
end
