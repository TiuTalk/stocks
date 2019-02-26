require 'rails_helper'

RSpec.describe OperationListener, type: :listener do
  let!(:stock) { create_default(:stock) }
  let!(:wallet) { create_default(:wallet) }

  describe '#after_create' do
    it 'calls HoldingCalculator and WalletHistoryCalculator' do
      expect(HoldingCalculator).to receive(:call_async).with(wallet, stock)
      create(:purchase, quantity: 50)
    end
  end

  describe '#after_update' do
    it 'calls HoldingCalculator and WalletHistoryCalculator' do
      operation = create(:purchase, quantity: 50)
      expect(HoldingCalculator).to receive(:call_async).with(wallet, stock)
      operation.update(quantity: 10)
    end
  end

  describe '#after_destroy', sidekiq: :inline do
    context 'with remaining holdings' do
      it 'keep the Holding record' do
        create(:purchase, quantity: 10)
        operation = create(:purchase, quantity: 5)

        expect(Holding.last.quantity).to eq(10 + 5)

        expect do
          operation.destroy!
        end.to_not change(Holding, :count)

        expect(Holding.last.quantity).to eq(10)
      end
    end

    context 'without remaining holdings' do
      it 'deletes the Holding record' do
        operation = create(:purchase, quantity: 5)

        expect do
          operation.destroy!
        end.to change(Holding, :count).by(-1)
      end
    end
  end
end
