require 'rails_helper'

RSpec.describe Sector, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:sectors) }
    it { is_expected.to have_many(:stocks).inverse_of(:sector).dependent(:destroy) }
    it { is_expected.to have_many(:fiis).class_name('FII').inverse_of(:sector).dependent(:destroy) }
    it { is_expected.to have_many(:etfs).class_name('ETF').inverse_of(:sector).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
