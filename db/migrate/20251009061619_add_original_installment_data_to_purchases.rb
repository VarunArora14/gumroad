class AddOriginalInstallmentDataToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :original_installment_plan_id, :bigint
    add_column :purchases, :original_purchase_price_cents, :integer

    add_index :purchases, :original_installment_plan_id
  end
end
