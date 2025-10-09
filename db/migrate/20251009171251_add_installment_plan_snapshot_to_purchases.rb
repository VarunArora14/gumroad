# frozen_string_literal: true

class AddInstallmentPlanSnapshotToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :installment_plan_id, :bigint
    add_column :purchases, :installment_number_of_installments, :integer
    add_column :purchases, :installment_payment_amounts_cents, :text

    add_index :purchases, :installment_plan_id
    add_foreign_key :purchases, :product_installment_plans, column: :installment_plan_id
  end
end
