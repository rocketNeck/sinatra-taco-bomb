class Order < ActiveRecord::Base
  validates_presence_of :address, :total
  belongs_to :owner
  belongs_to :customer
  has_many :menu_item_orders
  has_many :menu_items, through: :menu_item_orders

  def add_menu_item(id)
    menu_item = MenuItem.find_by_id(id)
    self.total += menu_item.price
    menu_item.subtract_from_prepped
    self.menu_items.push(menu_item)
    self.status = "pending"
    self.save
  end
  #
  # def hanging
  #   self.where(status: "open" )
  # end

  def reset
    self.total = 0
    self.menu_items.each do |item|
      item.add_to_prepped
      item.save
    end
    self.menu_items.clear
  end
end
