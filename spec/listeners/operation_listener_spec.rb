require 'rails_helper'

RSpec.describe OperationListener, type: :listener do
  let(:stock) { create(:stock) }

  describe '#after_create' do
    context 'with Buy operation' do
      it 'creates the Holding record' do
        operation = build(:buy, stock: stock, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(operation.wallet)
        expect(holding.quantity).to eq(50)
      end

      it 'updates the existing Holding record' do
        previous_operation = create(:buy, stock: stock, quantity: 50)
        operation = build(:buy, stock: stock, wallet: previous_operation.wallet, quantity: 30)

        expect do
          operation.save!
        end.to_not change(Holding, :count)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(previous_operation.wallet)
        expect(holding.quantity).to eq(50 + 30)
      end
    end

    context 'with Sell operation' do
      it 'creates the Holding record' do
        operation = build(:sell, stock: stock, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(operation.wallet)
        expect(holding.quantity).to eq(-50)
      end

      it 'updates the existing Holding record' do
        previous_operation = create(:buy, stock: stock, quantity: 50)
        operation = build(:sell, stock: stock, wallet: previous_operation.wallet, quantity: 30)

        expect do
          operation.save!
        end.to_not change(Holding, :count)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(previous_operation.wallet)
        expect(holding.quantity).to eq(50 - 30)
      end
    end
  end

  describe '#after_update' do
    it 'recalculates holding' do
      operation = build(:buy, stock: stock, quantity: 50)

      expect do
        operation.save!
      end.to change(Holding, :count).by(1)

      holding = Holding.last
      expect(holding.stock).to eq(stock)
      expect(holding.wallet).to eq(operation.wallet)
      expect(holding.quantity).to eq(50)

      expect do
        operation.update!(quantity: 40)
      end.to_not change(Holding, :count)

      expect(holding.reload.quantity).to eq(40)
    end
  end
end
