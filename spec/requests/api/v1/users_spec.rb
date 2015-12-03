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

    context 'authorized' do
      before do
        user
      end
      context 'User with role :user' do
        let(:user){ FactoryGirl.create(:user, role: Role::USER) }
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
                  role: [Role::USER, Role::GUEST].sample
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
      context 'User with non :admin role' do
        let(:user){ FactoryGirl.create(:user, role: Role::USER) }
        it 'can not create an user with role :admin' do
          expect do
            post(
              '/api/users',
              headers: headers_with_crendetionals,
              params: {
                user: {
                  login: 'alice',
                  password: 'topsecret',
                  password_confirmation: 'topsecret',
                  role: Role::ADMIN
                }
              }
            )
          end.to_not change{User.count}

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'User with role :guest' do
        let(:user){ FactoryGirl.create(:user, role: Role::GUEST) }
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
                  role: Role::USER
                }
              }
            )
          end.to_not change{User.count}

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'User with role :admin' do
        let(:user){ FactoryGirl.create(:user, role: Role::ADMIN) }
        before do
          user
        end
        it 'can create an user with any role' do
          expect do
            post(
              '/api/users',
              headers: headers_with_crendetionals,
              params: {
                user: {
                  login: 'alice',
                  password: 'topsecret',
                  password_confirmation: 'topsecret',
                  role: [Role::USER, Role::GUEST, Role::ADMIN].sample
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
