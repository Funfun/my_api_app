require 'rails_helper'

describe 'stories API' do
  describe 'GET /api/epics/1/stories' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/epics/1/stories', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      let(:epic){ FactoryGirl.create(:epic) }
      let!(:story){ FactoryGirl.create(:story, epic: epic) }

      it 'send a list of stories' do
        get "/api/epics/#{epic.id}/stories", headers: headers_with_random_crendetionals

        expect(response).to have_http_status(:success)
        expect(json.length).to eq(1)
      end
    end
  end

  describe 'POST /api/epics/1/stories' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        post '/api/epics/1/stories', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    let(:story_params) do
      {
        story: {
          body: 'Sample body'
        }
      }
    end
    let(:expected_body) do
      {'body' => story_params[:story][:body], 'status' => 1, 'epic_id' => 1, 'id' => be_kind_of(Integer)}
    end
    context 'User with role :guest' do
      it 'can not create a story' do
        post '/api/epics/1/stories', headers: headers_with_guest_crendetionals, params: story_params

        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'User with role :user' do
      it 'creates a story' do
        post '/api/epics/1/stories', headers: headers_with_user_crendetionals, params: story_params

        expect(response).to have_http_status(:created)
        expect(json).to include(expected_body)
      end
    end
    context 'User with role :admin' do
      it 'creates a story' do
        post '/api/epics/1/stories', headers: headers_with_admin_crendetionals, params: story_params

        expect(response).to have_http_status(:created)
        expect(json).to include(expected_body)
      end
    end
  end

  describe 'GET /api/epics/1/stories/2' do
    let(:epic){ FactoryGirl.create(:epic) }
    let(:story){ FactoryGirl.create(:story, epic: epic) }

    context 'anonymous' do
      it 'forbidden to access this resource' do
        get "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      let(:expected_body) do
        {'body' => story.body, 'status' => story.status, 'epic_id' => epic.id, 'id' => story.id}
      end
      it 'retrieves a specific story' do
        get "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_random_crendetionals

        expect(response).to have_http_status(:success)
        expect(json).to include(expected_body)
      end
    end
  end

  describe 'PUT /api/epics/1/stories/2' do
    let(:epic){ FactoryGirl.create(:epic) }
    let(:story){ FactoryGirl.create(:story, epic: epic) }

    context 'anonymous' do
      it 'forbidden to access this resource' do
        put "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers, params: {story: {body: 'text'}}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :guest' do
      it 'can not update a story' do
        put "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_guest_crendetionals

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :user' do
      it 'updates only authored story' do
        story.user_id = user.id
        story.save
        put "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_user_crendetionals, params: {story: {body: 'new data'}}

        expect(response).to have_http_status(:success)
        expect(json).to include('id' => story.id)
      end

      it 'can not update others stories' do
        story.user_id = user.id + 1000
        story.save
        put "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_user_crendetionals, params: {story: {body: 'new data'}}
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :admin' do
      it 'updates any story' do
        story.user_id = admin.id + 1000
        story.save
        put "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_admin_crendetionals, params: {story: {body: 'new data'}}
        expect(response).to have_http_status(:success)
        expect(json).to include('id' => story.id)
      end
    end
  end

  describe 'DELETE /api/epics/1/stories/2' do
    let(:epic){ FactoryGirl.create(:epic) }
    let(:story){ FactoryGirl.create(:story, epic: epic) }

    context 'anonymous' do
      it 'forbidden to access this resource' do
        delete "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :guest' do
      it 'can not delete a story' do
        delete "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_guest_crendetionals

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :user' do
      it 'deletes only authored story' do
        story.user_id = user.id
        story.save
        delete "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:no_content)
      end

      it 'can not delete others storie' do
        story.user_id = user.id + 1000
        story.save
        delete "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :admin' do
      it 'deletes any story' do
        delete "/api/epics/#{epic.id}/stories/#{story.id}", headers: headers_with_admin_crendetionals

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
