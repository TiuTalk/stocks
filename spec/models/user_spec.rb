require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    xit { is_expected.to have_many(:wallets).inverse_of(:user).dependent(:destroy) }
  end

  describe 'validations' do
    %i[name email].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    context 'email' do
      subject { build(:user) }

      it 'validates format' do
        is_expected.to allow_values('email@example.com', 'email.with.dots@dom.ain.com').for(:email)
        is_expected.to_not allow_values('@example.com', 'test', '').for(:email)
      end
    end
  end
end
