module Helpers
  def json
    JSON.parse(response.body)
  end

  def headers
    {
      'Accept' => 'application/vnd.example.v1'
    }
  end

  def random_user
    @user_with_random_role ||= FactoryGirl.create(:user, id: 1)
  end

  def user
    @user ||= FactoryGirl.create(:user, role: Role::USER)
  end

  def guest
    @guest ||= FactoryGirl.create(:user, role: Role::GUEST)
  end

  def admin
    @admin ||= FactoryGirl.create(:user, login: 'alice', role: Role::ADMIN)
  end

  def headers_with_random_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(random_user.login, 'secret')
    )
  end

  def headers_with_admin_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(admin.login, 'secret')
    )
  end

  def headers_with_user_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.login, 'secret')
    )
  end

  def headers_with_guest_crendetionals
    headers.merge(
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(guest.login, 'secret')
    )
  end
end
