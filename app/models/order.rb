class Order < ActiveRecord::Base
  validates_presence_of :address, :total
  belongs_to :owner
  belongs_to :customer
  has_many :menu_item_orders
  has_many :menu_items, through: :menu_item_orders

  def add_menu_item(id)
    item = MenuItem.find_by(id)
    self.total += item.price
    item.subtract_from_prepped
    self.menu_items.push(item)
  end

  def hanging
    Order.find_by_sql("SELECT orders.* WHERE status == "hanging" ORDER BY created_at ASC")
  end

  def reset
    self.total = 0
    self.menu_items.each do |item|
      item.add_to_prepped
    end
    self.menu_items.clear
  end
end
