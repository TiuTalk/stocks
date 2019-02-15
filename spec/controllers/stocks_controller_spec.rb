require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  describe 'GET #show' do
    let(:stock) { create(:stock) }

    it 'returns http success' do
      get :show, params: { id: stock.ticker }
      expect(response).to have_http_status(:success)
    end
  end
end
