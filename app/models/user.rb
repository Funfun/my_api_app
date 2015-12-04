class User < ActiveRecord::Base
  has_secure_password

  has_many :stories

  def self.authenticate(login, password)
    user = User.find_by(login: login)
    return user if user.try(:authenticate, password)
  end
end
