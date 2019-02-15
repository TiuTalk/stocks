require 'rails_helper'

RSpec.describe FII, type: :model do
  describe 'inheritance' do
    it { is_expected.to be_a(Stock) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:fiis) }
  end

  describe 'validations' do
    %i[name ticker stock_exchange].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe '#benchmark' do
    context 'B3' do
      let(:b3) { create(:stock_exchange, :b3) }
      let!(:fii) { create(:fii, stock_exchange: b3) }
      let!(:ifix11) { create(:etf, :ifix11) }

      it 'returns IFIX11' do
        expect(fii.benchmark).to eq(ifix11)
      end
    end

    context 'NYSE' do
      it 'returns the benchmark ticker'
    end
  end
end
