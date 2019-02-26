require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  describe 'GET #show' do
    let(:wallet) { create(:wallet) }

    it 'returns http success' do
      get :show, params: { id: wallet.id }
      expect(response).to have_http_status(:success)
    end
  end
end
