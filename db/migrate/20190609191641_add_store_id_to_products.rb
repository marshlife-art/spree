class AddStoreIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :store_id, :integer
    add_index :spree_products, :store_id
    
    if Spree::Store.default.persisted?
      Spree::Product.where(store_id: nil).update_all(store_id: Spree::Store.default.id)
    end
  end
end
