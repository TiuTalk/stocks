require 'rails_helper'

RSpec.describe HoldingCalculator, type: :service do
  let!(:stock) { create_default(:stock) }
  let!(:wallet) { create_default(:wallet) }
  let(:holding) { Holding.last }

  # Temporarily disable the OperationListener
  before { allow_any_instance_of(OperationListener).to receive(:recalculate_holding) }

  it 'calculates accounting values correctly' do
    operation = create(:purchase, quantity: 100, price: 17.88, taxes: 1.49)
    described_class.call(wallet, stock)
    expect(holding.reload.quantity).to eq(100)
    expect(holding.average_price).to eq(17.89)
    expect(holding.accounting_average_price).to eq(17.89)
    expect(holding.invested).to eq(operation.total)

    operation = create(:purchase, quantity: 100, price: 16.85, taxes: 1.49)
    described_class.call(wallet, stock)
    expect(holding.reload.quantity).to eq(200)
    expect(holding.average_price).to eq(17.38)
    expect(holding.accounting_average_price).to eq(17.38)
    expect(holding.invested).to eq(1789.49 + operation.total)

    operation = create(:purchase, quantity: 32, price: 16.0, taxes: 1.49)
    described_class.call(wallet, stock)
    expect(holding.reload.quantity).to eq(232)
    expect(holding.average_price).to eq(17.2)
    expect(holding.accounting_average_price).to eq(17.2)
    expect(holding.invested).to eq(3475.98 + operation.total)

    operation = create(:sale, quantity: 50, price: 17.0, taxes: 1.49)
    described_class.call(wallet, stock)
    expect(holding.reload.quantity).to eq(182)
    expect(holding.average_price).to eq(17.24) # TODO: Check this!
    expect(holding.accounting_average_price).to eq(17.2) # Doesn't change with sales
    expect(holding.invested).to eq(3989.47 - operation.total)
  end
end
