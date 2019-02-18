require 'rails_helper'

RSpec.describe Admin::StockExchangesController, type: :controller do
  let(:stock_exchange) { create(:stock_exchange) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: stock_exchange.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#display_resource' do
    it 'return the stock_exchange name' do
      expect(controller.send(:dashboard).display_resource(stock_exchange)). to eq(stock_exchange.name)
    end
  end
end
