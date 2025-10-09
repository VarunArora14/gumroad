class BackfillOriginalInstallmentData < ActiveRecord::Migration[7.1]
  def up
    # Backfill installment purchase data
    Purchase.where(original_installment_plan_id: nil)
            .find_each do |purchase|
      next unless purchase.is_installment_payment?
      next unless purchase.link.installment_plan.present?

      purchase.update!(
        original_installment_plan_id: purchase.link.installment_plan.id,
        original_purchase_price_cents: purchase.displayed_price_cents
      )
    end
  end

  def down
    # Remove the backfilled data
    Purchase.where.not(original_installment_plan_id: nil)
            .update_all(
              original_installment_plan_id: nil,
              original_purchase_price_cents: nil
            )
  end
end
