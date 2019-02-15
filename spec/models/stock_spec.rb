require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:stocks) }
    it { is_expected.to have_many(:quotes).inverse_of(:stock).dependent(:destroy) }
  end

  describe 'validations' do
    %i[name ticker stock_exchange].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    context 'ticker' do
      subject { build(:stock) }
      it { is_expected.to validate_uniqueness_of(:ticker).scoped_to(:stock_exchange_id) }
    end
  end

  describe '#alpha_advantage_symbol' do
    it 'combines the StockExchange#alpha_advantage_code with the Stock#ticker' do
      stock = build(:stock, :itsa4)
      expect(stock.alpha_advantage_symbol).to eq('ITSA4.SAO')
    end
  end
end
