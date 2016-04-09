class SpellingFixForPrepped < ActiveRecord::Migration
  def change
    rename_column(:menu_items, :current_number_preped, :current_number_prepped)
  end
end
