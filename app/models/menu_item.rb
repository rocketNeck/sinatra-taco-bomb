class MenuItem < ActiveRecord::Base
  validates :description, length: {maximum: 100, too_long: "%{count} characters max for formating"}
  validates_presence_of :price, :description, :img_path, :name
  belongs_to :owner
  has_many :menu_item_orders
  has_many :orders, through: :menu_item_orders
end
