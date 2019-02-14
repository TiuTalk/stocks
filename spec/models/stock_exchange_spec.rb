require 'rails_helper'

RSpec.describe StockExchange, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:stocks).inverse_of(:stock_exchange).dependent(:destroy) }
  end

  describe 'validations' do
    %i[name code alpha_advantage_code country timeonze open close].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe 'scopes' do
    describe '#b3' do
      it 'return the B3 exchange' do
        b3 = create(:stock_exchange, :b3)
        _nyse = create(:stock_exchange, :nyse)

        expect(described_class.unscoped.b3).to eq(b3)
      end
    end

    describe '#nyse' do
      it 'return the NYSE exchange' do
        _b3 = create(:stock_exchange, :b3)
        nyse = create(:stock_exchange, :nyse)

        expect(described_class.unscoped.nyse).to eq(nyse)
      end
    end
  end
end
