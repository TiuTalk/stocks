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
end
