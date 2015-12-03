module Helpers
  def json
    JSON.parse(response.body)
  end

  def headers
    {
      'Accept' => 'application/vnd.example.v1'
    }
  end

  def user
    @user ||= FactoryGirl.create(:user, id: 1)
  end

  def admin
    @admin ||= FactoryGirl.create(:user, id: 9, login: 'alice', role: Role::ADMIN)
  end

  def headers_with_user_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.login, 'secret')
    )
  end

  def headers_with_admin_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(admin.login, 'secret')
    )
  end
end
