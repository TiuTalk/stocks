require 'rails_helper'

RSpec.describe WalletHistoryCalculator, type: :service do
  let!(:wallet) { create_default(:wallet) }

  let(:stock_a) { create(:stock) }
  let(:stock_b) { create(:stock) }

  # Temporarily disable the OperationListener
  before { allow_any_instance_of(OperationListener).to receive(:recalculate_wallet_history) }

  before do
    create(:purchase, stock: stock_a, quantity: 100, price: 17.88, taxes: 1.49, date: 4.days.ago)
    create(:purchase, stock: stock_b, quantity: 30, price: 16.85, taxes: 1.49, date: 2.days.ago)
    create(:purchase, stock: stock_a, quantity: 50, price: 16.85, taxes: 1.49, date: 2.days.ago)

    create(:quote, stock: stock_a, close: 5.0, date: 4.days.ago)
    create(:quote, stock: stock_a, close: 8.0, date: 2.days.ago)

    create(:quote, stock: stock_b, close: 20.0, date: 4.days.ago)
    create(:quote, stock: stock_b, close: 21.13, date: 2.days.ago)
  end

  context 'with date before the first purchase' do
    it 'do nothing' do
      expect do
        described_class.call(wallet, 5.days.ago)
      end.to_not change(WalletHistory, :count)
    end
  end

  context 'with date after first purchase' do
    it 'calculate the correct invested & value sums' do
      expect do
        described_class.call(wallet, 4.days.ago)
      end.to change(WalletHistory, :count).by(1)

      history = WalletHistory.last
      expect(history.wallet).to eq(wallet)
      expect(history.invested).to eq((100 * 17.88) + 1.49)
      expect(history.value).to eq(100 * 5.0)
    end
  end

  context 'with date after second purchase' do
    it 'calculate the correct invested & value sums' do
      expect do
        described_class.call(wallet, 2.days.ago)
      end.to change(WalletHistory, :count).by(1)

      history = WalletHistory.last
      expect(history.wallet).to eq(wallet)

      invested = (100 * 17.88) + 1.49
      invested += (30 * 16.85) + 1.49
      invested += (50 * 16.85) + 1.49
      expect(history.invested).to eq(invested)

      value = (150 * 8) + (30 * 21.13)
      expect(history.value).to eq(value)
    end
  end

  context 'with date after last known quote' do
    it 'calculate the correct invested & value sums' do
      expect do
        described_class.call(wallet, 1.day.ago)
      end.to change(WalletHistory, :count).by(1)

      history = WalletHistory.last
      expect(history.wallet).to eq(wallet)

      invested = (100 * 17.88) + 1.49
      invested += (30 * 16.85) + 1.49
      invested += (50 * 16.85) + 1.49
      expect(history.invested).to eq(invested)

      value = (150 * 8) + (30 * 21.13)
      expect(history.value).to eq(value)
    end
  end
end
