class CreateMenuItemOrders < ActiveRecord::Migration
  def change
    create_table :menu_item_orders do |t|
      t.integer :menu_item_id
      t.integer :order_id
    end
  end
end
