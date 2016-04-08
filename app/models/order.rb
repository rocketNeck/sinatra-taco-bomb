class Order < ActiveRecord::Base
  validates_presence_of :address, :total
  belongs_to :owner
  belongs_to :customer
  has_many :menu_item_orders
  has_many :menu_items, through: :menu_item_orders
end
