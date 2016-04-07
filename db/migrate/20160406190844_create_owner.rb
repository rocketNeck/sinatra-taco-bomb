class CreateOwner < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :password_digest
      t.string :payment_info

      t.datetime :created_at
      t.datetime :updated_at
      t.integer :admin_id
    end
  end
end
