require 'rails_helper'

RSpec.describe Holding, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wallet).inverse_of(:holdings) }
    it { is_expected.to belong_to(:stock).inverse_of(:holdings) }
  end
end
