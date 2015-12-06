require "rails_helper"

describe 'Sessions API', :type => :request do
  describe 'POST /api/users' do
    context 'anonymous' do
      it 'retrieves authenticated user information' do
        post '/api/sessions', headers: headers_with_random_crendetionals

        expect(response).to have_http_status(:success)
      end
    end
  end
end
