require 'bcrypt'
class Owner < ActiveRecord::Base
  has_secure_password
  validates_presence_of :email, :password_digest, :name
  validates :password_digest, uniqueness: true, on: :create
  validates :email, uniqueness: true, on: :create

  has_many :menu_items
  has_many :orders
  has_many :customers, through: :orders
  belongs_to :admin

  def slug
    self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    self.all.find{|i| i.slug == slug}
  end
end
