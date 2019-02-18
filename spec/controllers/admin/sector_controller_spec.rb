require 'rails_helper'

RSpec.describe Admin::SectorsController, type: :controller do
  let(:sector) { create(:sector) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: sector.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#display_resource' do
    it 'return the sector name' do
      expect(controller.send(:dashboard).display_resource(sector)). to eq(sector.name)
    end
  end
end
