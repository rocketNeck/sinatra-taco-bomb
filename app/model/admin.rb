require 'bcrypt'
class Admin < ActiveRecord::Base
  has_secure_password
  validates_presence_of :email, :password_digest
  validates :password_digest, uniqueness: true, on: :create
  validates :email, uniqueness: true, on: :create
  has_many :owners
end
