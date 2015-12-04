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
        get '/api/epics', headers: headers_with_random_crendetionals

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
        get '/api/epics/1', headers: headers_with_random_crendetionals

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

    context 'User with role :admin' do
      it 'can create an epic' do
        expect do
          post(
            '/api/epics',
            headers: headers_with_admin_crendetionals,
            params: {
              epic: {
                title: 'sample',
                description: 'foo',
                priority: 2
              }
            }
          )
        end.to change{Epic.count}.by(1)

        expect(response).to have_http_status(:created)

        expect(json).to include({'id' => a_kind_of(Integer), 'title' => 'sample', 'description' => 'foo', 'priority' => 2})
      end
    end

    context 'User with non :admin role' do
      it 'can create an epic' do
        expect do
          post(
            '/api/epics',
            headers: headers_with_user_crendetionals,
            params: {
              epic: {
                title: 'sample',
                description: 'foo',
                priority: 2
              }
            }
          )
        end.to_not change{Epic.count}

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
