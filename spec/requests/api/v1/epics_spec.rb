require 'rails_helper'

describe 'Epics API' do
  describe 'GET /api/epics' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/epics', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      let!(:epic){ FactoryGirl.create(:epic) }
      it 'sends a list of epics' do
        get '/api/epics', headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:success)
        expect(json.length).to eq(1)
      end
    end
  end

  describe 'GET /api/epics/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/epics/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      let!(:epic){ FactoryGirl.create(:epic) }
      it 'retrieves a specific epic with id 1' do
        get '/api/epics/1', headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:success)
        expect(json).to eq({'id' => epic.id, 'title' => epic.title, 'description' => epic.description, 'priority' => epic.priority})
      end
    end
  end

  describe 'POST /api/epics' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        post '/api/epics', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :user or :admin' do
      it 'creates an epic'
    end
  end

  describe 'PUT /api/epics/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        put '/api/epics/1', headers: headers, params: {epic: {}}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :user' do
      it 'updates only authored epic'
    end
    context 'User with role :admin' do
      it 'updates any epic'
    end
  end

  describe 'DELETE /api/epics/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        delete '/api/epics/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :user' do
      it 'deletes only authored epic'
    end
    context 'User with role :admin' do
      it 'deletes any epic'
    end
  end
end
