require 'rails_helper'

RSpec.describe StockExchange, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:sectors).inverse_of(:stock_exchange).dependent(:destroy) }
    it { is_expected.to have_many(:stocks).inverse_of(:stock_exchange).dependent(:destroy) }
    it { is_expected.to have_many(:fiis).class_name('FII').inverse_of(:stock_exchange).dependent(:destroy) }
    it { is_expected.to have_many(:etfs).class_name('ETF').inverse_of(:stock_exchange).dependent(:destroy) }
    it { is_expected.to have_many(:wallets).inverse_of(:stock_exchange).dependent(:destroy) }
  end

  describe 'validations' do
    %i[name code alpha_vantage_code country timeonze open close].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe 'scopes' do
    describe '#b3' do
      it 'return the B3 exchange' do
        b3 = create(:stock_exchange, :b3)
        _other = create(:stock_exchange)

        expect(described_class.unscoped.b3).to eq(b3)
      end
    end

    describe '#nyse' do
      it 'return the NYSE exchange'
    end
  end
end
