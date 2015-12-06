require "rails_helper"

describe 'Sessions API', :type => :request do
  describe 'POST /api/users' do
    context 'anonymous' do
      it 'retrieves authenticated user information with correct crendetionals' do
        post '/api/sessions', headers: headers_with_random_crendetionals

        expect(response).to have_http_status(:success)
        expect(json).to include('id' => be_kind_of(Integer), 'login' => be_kind_of(String))
      end
    end
  end
end
