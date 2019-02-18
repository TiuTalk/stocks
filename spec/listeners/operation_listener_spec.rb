require 'rails_helper'

RSpec.describe OperationListener, type: :listener do
  let!(:stock) { create_default(:stock) }
  let!(:wallet) { create_default(:wallet) }

  describe '#after_create' do
    context 'with Purchase operation' do
      it 'creates the Holding record' do
        operation = build(:purchase, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(wallet)
        expect(holding.quantity).to eq(50)
      end

      it 'updates the existing Holding record' do
        create(:purchase, quantity: 50)
        operation = build(:purchase, quantity: 30)

        expect do
          operation.save!
        end.to_not change(Holding, :count)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(wallet)
        expect(holding.quantity).to eq(50 + 30)
      end
    end

    context 'with Sale operation' do
      it 'creates the Holding record' do
        operation = build(:sale, quantity: 50)

        expect do
          operation.save!
        end.to change(Holding, :count).by(1)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(wallet)
        expect(holding.quantity).to eq(-50)
      end

      it 'updates the existing Holding record' do
        create(:purchase, quantity: 50)
        operation = build(:sale, quantity: 30)

        expect do
          operation.save!
        end.to_not change(Holding, :count)

        holding = Holding.last
        expect(holding.stock).to eq(stock)
        expect(holding.wallet).to eq(wallet)
        expect(holding.quantity).to eq(50 - 30)
      end
    end
  end

  describe '#after_update' do
    it 'recalculates holding' do
      operation = build(:purchase, quantity: 50)

      expect do
        operation.save!
      end.to change(Holding, :count).by(1)

      holding = Holding.last
      expect(holding.stock).to eq(stock)
      expect(holding.wallet).to eq(wallet)
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
