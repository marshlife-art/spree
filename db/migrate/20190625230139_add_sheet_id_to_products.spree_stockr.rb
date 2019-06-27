# This migration comes from spree_stockr (originally 20190624214515)
class AddSheetIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :sheet_id, :integer
    add_index :spree_products, :sheet_id
  end
end
