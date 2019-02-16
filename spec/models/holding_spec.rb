require 'rails_helper'

RSpec.describe Holding, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wallet).inverse_of(:holdings) }
    it { is_expected.to belong_to(:stock).inverse_of(:holdings) }
  end

  describe 'callbacks' do
    context 'after_save' do
      it 'destroy holding if quantity is zero' do
        holding = create(:holding)

        expect do
          holding.update(quantity: 0)
        end.to change(Holding, :count).by(-1)
      end
    end
  end
end
