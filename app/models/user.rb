class User < ActiveRecord::Base
  devise :validatable, :rememberable, :validatable

  attr_protected :encrypted_password, :password_salt, :remember_token, :remember_created_at
end
