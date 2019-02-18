require 'rails_helper'

RSpec.describe Admin::StocksController, type: :controller do
  let(:stock) { create(:stock) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: stock.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#display_resource' do
    it 'return the stock name' do
      expect(controller.send(:dashboard).display_resource(stock)). to eq(stock.ticker)
    end
  end
end
