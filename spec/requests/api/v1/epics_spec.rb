require 'rails_helper'

describe 'Epics API' do
  describe 'GET /api/epics' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with any role' do
      it 'sends a list of epics'
    end
  end

  describe 'GET /api/epics/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with any role' do
      it 'retrieves a specific epic with id 1'
    end
  end

  describe 'POST /api/epics' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :user or :admin' do
      it 'creates an epic'
    end
  end

  describe 'PUT /api/epics/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
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
