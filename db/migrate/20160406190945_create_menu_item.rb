class CreateMenuItem < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :price
      t.text :description
      t.string :img_path
      t.integer :current_number_preped
      t.integer :owner_id
    end
  end
end
