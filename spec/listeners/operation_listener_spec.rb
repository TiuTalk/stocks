require 'rails_helper'

RSpec.describe OperationListener, type: :listener do
  let(:stock) { create(:stock) }

  describe '#after_create' do
    context 'with Purchase operation' do
      it 'creates the Holding record' do
        operation = build(:purchase, stock: stock, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(operation.wallet)
        expect(holding.quantity).to eq(50)
      end

      it 'updates the existing Holding record' do
        previous_operation = create(:purchase, stock: stock, quantity: 50)
        operation = build(:purchase, stock: stock, wallet: previous_operation.wallet, quantity: 30)

        expect do
          operation.save!
        end.to_not change(Holding, :count)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(previous_operation.wallet)
        expect(holding.quantity).to eq(50 + 30)
      end
    end

    context 'with Sale operation' do
      it 'creates the Holding record' do
        operation = build(:sale, stock: stock, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(operation.wallet)
        expect(holding.quantity).to eq(-50)
      end

      it 'updates the existing Holding record' do
        previous_operation = create(:purchase, stock: stock, quantity: 50)
        operation = build(:sale, stock: stock, wallet: previous_operation.wallet, quantity: 30)

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
      operation = build(:purchase, stock: stock, quantity: 50)

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

  describe '#after_destroy' do
    context 'with remaining holdings' do
      it 'keep the Holding record' do
        previous_operation = create(:purchase, stock: stock, quantity: 10)
        operation = create(:purchase, stock: stock, wallet: previous_operation.wallet, quantity: 5)

        expect(Holding.last.quantity).to eq(10 + 5)

        expect do
          operation.destroy!
        end.to_not change(Holding, :count)

        expect(Holding.last.quantity).to eq(10)
      end
    end

    context 'without remaining holdings' do
      it 'deletes the Holding record' do
        operation = create(:purchase, stock: stock, quantity: 5)

        expect do
          operation.destroy!
        end.to change(Holding, :count).by(-1)
      end
    end
  end
end
