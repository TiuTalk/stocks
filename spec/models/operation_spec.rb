require 'rails_helper'

RSpec.describe Operation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wallet).inverse_of(:operations) }
    it { is_expected.to belong_to(:stock).inverse_of(:operations) }
  end

  describe 'validations' do
    %i[quantity price total date].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    %i[price taxes].each do |attr|
      it { is_expected.to validate_numericality_of(attr).is_greater_than_or_equal_to(0) }
    end

    it { is_expected.to validate_numericality_of(:quantity).only_integer }
    it { is_expected.to validate_numericality_of(:total) }
  end

  describe 'callbacks' do
    describe '#before_validation' do
      it 'calculate Operation total' do
        operation = build(:purchase, quantity: 100, price: 17.88, taxes: 1.49)
        expect { operation.save! }.to change { operation.total }.from(nil).to((100 * 17.88) + 1.49)
      end
    end
  end
end
