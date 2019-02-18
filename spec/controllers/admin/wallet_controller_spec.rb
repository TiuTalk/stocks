require 'rails_helper'

RSpec.describe Admin::WalletsController, type: :controller do
  let(:wallet) { create(:wallet) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: wallet.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#display_resource' do
    it 'return the wallet name' do
      expect(controller.send(:dashboard).display_resource(wallet)). to eq(wallet.name)
    end
  end
end
