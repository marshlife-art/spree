# This migration comes from spree_promotion_roles_rule (originally 20130604122813)
class CreateSpreePromotionRulesRoles < SpreeExtension::Migration[4.2]
  def up
    create_table :roles_promotion_rules do |t|
      t.integer :role_id
      t.integer :promotion_rule_id
    end
    add_index :roles_promotion_rules, :role_id
    add_index :roles_promotion_rules, :promotion_rule_id
  end

  def down
    drop_table :roles_promotion_rules
  end
end
