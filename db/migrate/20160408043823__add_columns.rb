class AddColumns < ActiveRecord::Migration
  def change
    rename_column(:owners, :address, :city)
  end
end
