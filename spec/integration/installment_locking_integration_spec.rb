# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Installment Locking Integration", type: :integration do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product, user: seller, price_cents: 1000) }
  let(:installment_plan) { create(:product_installment_plan, link: product, number_of_installments: 3) }
  let(:credit_card) { create(:credit_card, user: buyer) }

  before do
    product.installment_plan = installment_plan
    product.save!
  end

  describe "complete installment purchase flow" do
    it "locks installment terms at purchase time and maintains them through product changes" do
      # Step 1: Create initial purchase
      purchase = build(:purchase,
                       link: product,
                       purchaser: buyer,
                       seller: seller,
                       displayed_price_cents: 1000,
                       is_installment_payment: true).tap { |p| p.save!(validate: false) }

      # Step 2: Create subscription (simulating purchase service)
      subscription = create(:subscription,
                           link: product,
                           user: buyer,
                           is_installment_plan: true,
                           charge_occurrence_count: 3,
                           original_purchase: purchase)

      purchase.update_column(:subscription_id, subscription.id)

      # Step 3: Store original installment data
      purchase.store_original_installment_data!(validate: false)

      # Verify original data is stored
      expect(purchase.original_installment_plan_id).to eq(installment_plan.id)
      expect(purchase.original_purchase_price_cents).to eq(1000)

      # Step 4: Change product configuration
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan,
                                   link: product,
                                   number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)

      # Step 5: Verify installment amounts remain locked to original terms
      original_amounts = [334, 333, 333] # 1000/3 with remainder on first

      original_amounts.each_with_index do |expected_amount, index|
        # Simulate different installment numbers
        allow(purchase.subscription).to receive(:purchases).and_return(
          double(successful: double(count: index))
        )

        installment_amount = purchase.calculate_installment_payment_price_cents(1000)
        expect(installment_amount).to eq(expected_amount)
      end

      # Step 6: Verify subscription uses original amounts
      # Since the original purchase is already successful, the next installment is the second one (333)
      expect(subscription.current_subscription_price_cents).to eq(333)
    end

    it "handles multiple purchases with different original terms" do
      # Create first purchase
      purchase1 = build(:purchase,
                        link: product,
                        purchaser: buyer,
                        seller: seller,
                        displayed_price_cents: 1000,
                        is_installment_payment: true).tap { |p| p.save!(validate: false) }

      purchase1.store_original_installment_data!(validate: false)

      # Change product configuration
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan,
                                   link: product,
                                   number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)

      # Create second purchase with new terms
      purchase2 = build(:purchase,
                        link: product,
                        purchaser: buyer,
                        seller: seller,
                        displayed_price_cents: 2000,
                        is_installment_payment: true).tap { |p| p.save!(validate: false) }

      purchase2.store_original_installment_data!(validate: false)

      # Verify each purchase maintains its original terms
      expect(purchase1.original_purchase_price_cents).to eq(1000)
      expect(purchase1.original_installment_plan_id).to eq(installment_plan.id)
      expect(purchase1.fetch_installment_plan.number_of_installments).to eq(3)

      expect(purchase2.original_purchase_price_cents).to eq(2000)
      expect(purchase2.fetch_installment_plan.number_of_installments).to eq(5)
    end

    it "maintains backward compatibility with existing purchases" do
      # Create purchase without original data (simulating old purchases)
      purchase = build(:purchase,
                       link: product,
                       purchaser: buyer,
                       seller: seller,
                       displayed_price_cents: 1000,
                       is_installment_payment: true).tap { |p| p.save!(validate: false) }

      # Change product configuration
      product.update!(price_cents: 2000)
      installment_plan.update!(number_of_installments: 5)

      # Should fall back to current product data
      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(2000)
      expect(purchase.fetch_installment_plan.number_of_installments).to eq(5)
    end
  end

  describe "recurring charge worker integration" do
    let(:purchase) do
      build(:purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             is_installment_payment: true).tap { |p| p.save!(validate: false) }
    end

    let(:subscription) do
      create(:subscription,
             link: product,
             user: buyer,
             is_installment_plan: true,
             charge_occurrence_count: 3,
             original_purchase: purchase)
    end

    before do
      purchase.update_column(:subscription_id, subscription.id)
      purchase.store_original_installment_data!(validate: false)
    end

    it "uses locked installment amounts in recurring charges" do
      # Change product configuration
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan,
                                   link: product,
                                   number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)

      # Build a new purchase for recurring charge
      new_purchase = subscription.build_purchase

      # The new purchase should use the original installment terms
      # Since charge_occurrence_count is 3, the next installment is the 4th charge (second installment of original plan)
      expect(new_purchase.minimum_paid_price_cents).to eq(333) # Second installment of original 1000/3
    end
  end
end
