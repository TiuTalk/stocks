require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:wallets) }
    it { is_expected.to belong_to(:stock_exchange).inverse_of(:wallets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
