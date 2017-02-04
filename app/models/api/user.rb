class Api::User < ApplicationRecord
  devise :database_authenticatable, :trackable, :lockable

  # Poor performance if there are many API::Users
  # Vulnerable to timing attacks
  def self.first_by_osdi_api_token(token)
    Api::User.all.detect { |u| u.valid_password?(token) }
  end

  def osdi_api_token=(value)
    self.password = value
  end
end
