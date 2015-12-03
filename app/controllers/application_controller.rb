class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include CanCan::ControllerAdditions
  before_action :authenticate

  protected

  def current_user
    @current_user
  end

  def authenticate
    if user = authenticate_with_http_basic { |login, password| puts(login+password); User.authenticate(login, password) }
      @current_user = user
    else
      request_http_basic_authentication
    end
  end
end
