require 'rails_helper'

describe 'Users API', :type => :request do
  let(:user){ FactoryGirl.create(:user, id: 1) }
  let(:admin){ FactoryGirl.create(:user, id: 9, login: 'alice', role: Role::ADMIN) }

  let(:headers) do
    {
      'Accept' => 'application/vnd.example.v1'
    }
  end

  let(:headers_with_user_crendetionals) do
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.login, 'secret')
    )
  end

  let(:headers_with_admin_crendetionals) do
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(admin.login, 'secret')
    )
  end

  describe 'GET /api/users' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/users', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      it 'sends a list of users' do
        get '/api/users', headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:success)
        expect(json).to eq([{'id' => user.id, 'login' => user.login, 'role' => user.role}])
      end
    end
  end

  describe 'GET /api/users/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        get '/api/users/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with any role' do
      it 'retrieves a specific user with id 1' do
        get '/api/users/1', headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:success)
        expect(json).to eq({'id' => user.id, 'login' => user.login, 'role' => user.role})
      end
    end
  end

  describe 'POST /api/users' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        post '/api/users', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      context 'User with role :user' do
        let!(:user){ FactoryGirl.create(:user, role: Role::USER) }
        let(:role){ [Role::USER, Role::GUEST].sample }

        it 'can create an user with role :user or :guest' do
          expect do
            post(
              '/api/users',
              headers: headers_with_user_crendetionals,
              params: {
                user: {
                  login: 'alice',
                  password: 'topsecret',
                  password_confirmation: 'topsecret',
                  role: role
                }
              }
            )
          end.to change{User.count}.by(1)

          expect(response).to have_http_status(:created)

          expect(json).to include('login' => 'alice', 'role' => role, 'id' => a_kind_of(Integer))
        end
      end
      context 'User with non :admin role' do
        let!(:user){ FactoryGirl.create(:user, role: Role::USER) }
        it 'can not create an user with role :admin' do
          expect do
            post(
              '/api/users',
              headers: headers_with_user_crendetionals,
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
        let!(:user){ FactoryGirl.create(:user, role: Role::GUEST) }
        it 'can not create an user' do
          expect do
            post(
              '/api/users',
              headers: headers_with_user_crendetionals,
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
        before do
          admin
        end
        let(:role){ [Role::USER, Role::GUEST, Role::ADMIN].sample }
        it 'can create an user with any role' do
          expect do
            post(
              '/api/users',
              headers: headers_with_admin_crendetionals,
              params: {
                user: {
                  login: 'alice',
                  password: 'topsecret',
                  password_confirmation: 'topsecret',
                  role: role
                }
              }
            )
          end.to change{User.count}.by(1)

          expect(response).to have_http_status(:created)

          expect(json).to include('login' => 'alice', 'role' => role, 'id' => a_kind_of(Integer))
        end
      end
    end
  end

  describe 'PUT /api/users/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        put '/api/users/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :user' do
      let!(:user){ FactoryGirl.create(:user, id: 1, login: 'alice', role: Role::USER) }

      it 'can update itself' do
        put '/api/users/1', headers: headers_with_user_crendetionals, params: {user: {login: 'bob'}}

        expect(response).to have_http_status(:no_content)
      end

      let!(:another_user){ FactoryGirl.create(:user, login: 'alex', id: 2) }
      it 'can not update other user' do
        put '/api/users/2', headers: headers_with_user_crendetionals, params: {user: {login: 'bob'}}

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User with role :admin' do
      let!(:another_user){ FactoryGirl.create(:user, login: 'alex', id: 2) }
      it 'can update any user' do
        put '/api/users/2', headers: headers_with_admin_crendetionals, params: {user: {login: 'bob'}}

        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE /api/users/1' do
    context 'anonymous' do
      it 'forbidden to access this resource' do
        delete '/api/users/1', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'User with role :admin' do
      before do
        user
      end
      it 'can delete any user' do
        delete '/api/users/1', headers: headers_with_admin_crendetionals

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'User with non :admin role' do
      it 'can not delete non of user' do
        delete '/api/users/1', headers: headers_with_user_crendetionals

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
