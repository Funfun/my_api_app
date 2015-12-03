class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authenticate

  protected

  def authenticate
    if authenticate_with_http_basic { |login, password| User.authenticate(login, password) }
    else
      head :forbidden
    end
  end
end
