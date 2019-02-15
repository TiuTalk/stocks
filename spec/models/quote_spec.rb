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

      it 'only accept dates in the past' do
        expect(subject).to allow_values(1.day.ago, 2.days.ago, 10.years.ago).for(:date)
        expect(subject).to_not allow_values(1.minute.ago, Time.zone.today, 1.day.from_now).for(:date)
      end
    end
  end
end
