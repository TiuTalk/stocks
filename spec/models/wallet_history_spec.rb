require 'rails_helper'

RSpec.describe WalletHistory, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wallet).inverse_of(:history) }
  end
end
