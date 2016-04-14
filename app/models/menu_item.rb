class MenuItem < ActiveRecord::Base
  validates :description, length: {maximum: 100, too_long: "%{count} characters max for formating"}
  validates_presence_of :price, :description, :img_path, :name
  belongs_to :owner
  has_many :menu_item_orders
  has_many :orders, through: :menu_item_orders

  def add_to_prepped(num = 1)
    self.current_number_prepped += num
    self.save
  end

  def subtract_from_prepped(num = 1)
    self.current_number_prepped -= num
    self.save
  end
end
