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
      it 'sends a list of stories'
    end
  end

  describe 'POST /api/epics/1/stories' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :user or :admin' do
      it 'creates a story'
    end
  end

  describe 'GET /api/epics/1/stories/2' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with any role' do
      it 'retrieves a specific story'
    end
  end

  describe 'PUT /api/epics/1/stories/2' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :user' do
      it 'updates only authored story'
    end

    context 'User with role :admin' do
      it 'updates any story'
    end
  end

  describe 'DELETE /api/epics/1/stories/2' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :user' do
      it 'deletes only authored story'
    end

    context 'User with role :admin' do
      it 'deletes any story'
    end
  end
end
