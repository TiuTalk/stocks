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

    %i[price taxes total].each do |attr|
      it { is_expected.to validate_numericality_of(attr).is_greater_than_or_equal_to(0) }
    end

    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  end
end
