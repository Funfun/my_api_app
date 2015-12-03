require 'rails_helper'

describe 'Users API' do
  let(:headers){
    {
      'Accept' => 'application/vnd.example.v1'
    }
  }
  let(:headers_with_crendetionals){
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.login, 'secret')
    )
  }
  let(:user){ FactoryGirl.create(:user, id: 1) }

  describe 'GET /api/users' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/users', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      it 'sends a list of users' do
        get '/api/users', headers: headers_with_crendetionals

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([{'id' => user.id, 'login' => user.login}])
      end
    end
  end

  describe 'GET /api/users/1' do
    before do
      user
    end
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/users/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      it 'retrieves a specific user with id 1' do
        get '/api/users/1', headers: headers_with_crendetionals

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({'id' => user.id, 'login' => user.login})
      end
    end
  end

  describe 'POST /api/users' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        post '/api/users', headers: headers, params: {login: 'alice'}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    xcontext 'User with role :guest' do
      let(:user_role){ FactoryGirl.create(:role, name: 'guest') }
      let(:user){ FactoryGirl.create(:user, role: user_role) }
      before do
        user
      end
      it 'can not create an user' do
        expect do
          post(
            '/api/users',
            headers: headers_with_crendetionals,
            params: {
              user: {
                login: 'alice',
                password: 'topsecret',
                password_confirmation: 'topsecret',
                role_id: user_role.id
              }
            }
          )
        end.to_not change{User.count}

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :user' do
      let(:user_role){ FactoryGirl.create(:role, name: 'user') }
      let(:user){ FactoryGirl.create(:user, role: user_role) }
      before do
        user
      end
      it 'can create an user with role :user or :guest' do
        expect do
          post(
            '/api/users',
            headers: headers_with_crendetionals,
            params: {
              user: {
                login: 'alice',
                password: 'topsecret',
                password_confirmation: 'topsecret',
                role_id: user_role.id
              }
            }
          )
        end.to change{User.count}.by(1)

        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)

        expect(body).to include('login' => 'alice')
        expect(body).to include('id' => a_kind_of(Integer))
      end
    end

    context 'User with role :admin' do
      it 'can create an user' do

      end
    end
  end

  describe 'PUT /api/users/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :user' do
      it 'updates only authored user'
    end

    context 'User with role :admin' do
      it 'updates any user'
    end
  end

  describe 'DELETE /api/users/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
      end
    end

    context 'User with role :admin' do
      it 'deletes any user'
    end
  end
end
