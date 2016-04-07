class CreateCustomer < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :payment_info

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
