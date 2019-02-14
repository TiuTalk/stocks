require 'rails_helper'

RSpec.describe Quote, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock).inverse_of(:quotes) }
  end

  describe 'validations' do
    %i[date stock].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    context 'date' do
      subject { build(:quote) }
      it { is_expected.to validate_uniqueness_of(:date).scoped_to(:stock_id) }
    end
  end
end
