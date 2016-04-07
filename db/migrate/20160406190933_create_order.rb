class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :total
      t.integer :owner_id
      t.integer :customer_id
      t.datetime :created_at
      t.datetime :closed_at
    end
  end
end
