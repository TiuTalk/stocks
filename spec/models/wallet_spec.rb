require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:wallets) }
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:wallets) }
    it { is_expected.to have_many(:holdings).inverse_of(:wallet).dependent(:destroy) }
    it { is_expected.to have_many(:stocks).through(:holdings).inverse_of(:wallets) }
    it { is_expected.to have_many(:operations).inverse_of(:wallet).dependent(:destroy) }
    it { is_expected.to have_many(:purchases).class_name('Operations::Purchase').inverse_of(:wallet).dependent(:destroy) }
    it { is_expected.to have_many(:sales).class_name('Operations::Sale').inverse_of(:wallet).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
