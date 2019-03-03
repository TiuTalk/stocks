require 'rails_helper'

RSpec.describe WalletPresenter, type: :presenter, sidekiq: :inline do
  subject(:presenter) { described_class.new(wallet) }

  let!(:wallet) { create_default(:wallet) }
  let(:stock_a) { create(:stock) }
  let(:stock_b) { create(:stock) }

  before do
    create(:purchase, stock: stock_a, quantity: 10, price: 12.5, taxes: 0)
    create(:purchase, stock: stock_b, quantity: 20, price: 6.15, taxes: 0)
    create(:sale, stock: stock_b, quantity: -5, price: 3.51, taxes: 0)

    allow(wallet).to receive_message_chain(:stocks, :includes).and_return([stock_a, stock_b])
    allow(stock_a).to receive(:quote).and_return(double(Quote, close: 23.54))
    allow(stock_b).to receive(:quote).and_return(double(Quote, close: 105.63))
  end

  describe '#total_invested' do
    it 'returns the sum of all wallet holdings investments' do
      expect(presenter.total_invested).to eq((10 * 12.5) + (20 * 6.15) - (5 * 3.51))
    end
  end

  describe '#total_value' do
    it 'returns the sum of all wallet holdings values' do
      expected = presenter.holding_value(stock_a) + presenter.holding_value(stock_b)
      expect(presenter.total_value).to eq(expected)
    end
  end

  describe '#total_return' do
    it 'return the return as %' do
      invested = presenter.total_invested
      value = presenter.total_value
      percentage = ((value - invested) / invested).round(2)

      expect(presenter.total_return).to eq(value - invested)
      expect(presenter.total_return_percentage).to eq(percentage)
    end
  end

  describe '#holding_value' do
    it 'returns the holding quantity times the stock quote' do
      expect(presenter.holding_value(stock_a)).to eq(10 * stock_a.quote.close)
      expect(presenter.holding_value(stock_b)).to eq(15 * stock_b.quote.close)
    end

    context 'with stock without quotes' do
      it 'returns zero' do
        expect(presenter.holding_value(create(:stock))).to be_zero
      end
    end
  end

  context 'with wallet that has no holdings' do
    subject(:presenter) { described_class.new(build_stubbed(:wallet)) }

    it { expect(presenter.total_invested).to be_zero }
    it { expect(presenter.total_value).to be_zero }
    it { expect(presenter.total_return).to be_zero }
    it { expect(presenter.total_return_percentage).to be_zero }
    it { expect(presenter.holding_value(stock_a)).to be_zero }
  end
end
