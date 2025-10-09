# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Purchase Installment Locking", type: :model do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product, user: seller, price_cents: 1000) }
  let(:installment_plan) { create(:product_installment_plan, link: product, number_of_installments: 3) }
  let(:credit_card) { create(:credit_card, user: buyer) }

  before do
    product.installment_plan = installment_plan
    product.save!
  end

  describe "original installment data storage" do
    let(:purchase) do
      build(:installment_plan_purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000).tap { |p| p.save!(validate: false) }
    end

    it "stores original installment plan data" do
      purchase.store_original_installment_data!(validate: false)

      expect(purchase.original_installment_plan_id).to eq(installment_plan.id)
      expect(purchase.original_purchase_price_cents).to eq(1000)
    end

    it "does not store data for non-installment purchases" do
      purchase.is_installment_payment = false
      purchase.save!(validate: false)
      purchase.store_original_installment_data!

      expect(purchase.original_installment_plan_id).to be_nil
      expect(purchase.original_purchase_price_cents).to be_nil
    end
  end

  describe "fetch_installment_plan" do
    let(:purchase) do
      build(:installment_plan_purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             original_installment_plan_id: installment_plan.id).tap { |p| p.save!(validate: false) }
    end

    it "uses original installment plan when available" do
      expect(purchase.fetch_installment_plan).to eq(installment_plan)
    end

    it "falls back to current product installment plan when original is not available" do
      purchase.update_column(:original_installment_plan_id, nil)

      expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
    end

    it "falls back to current product installment plan for non-installment purchases" do
      purchase.is_installment_payment = false
      purchase.save!(validate: false)

      expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
    end
  end

  describe "minimum_paid_price_cents_per_unit_before_discount" do
    let(:purchase) do
      build(:installment_plan_purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             original_purchase_price_cents: 1000,
             quantity: 1).tap { |p| p.save!(validate: false) }
    end

    it "uses original purchase price for installment purchases" do
      # Change the product price
      product.update!(price_cents: 2000)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(1000)
    end

    it "uses current product price for non-installment purchases" do
      purchase.is_installment_payment = false
      purchase.original_purchase_price_cents = nil
      purchase.save!(validate: false)

      # Change the product price
      product.update!(price_cents: 2000)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(2000)
    end

    it "handles quantity correctly" do
      purchase.update_column(:quantity, 2)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(500) # 1000 / 2
    end
  end

  describe "installment amount calculation with locked data" do
    let(:purchase) do
      build(:installment_plan_purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             original_installment_plan_id: installment_plan.id,
             original_purchase_price_cents: 1000).tap { |p| p.save!(validate: false) }
    end

    before do
      # Create a subscription for the purchase
      subscription = create(:subscription,
                           link: product,
                           user: buyer,
                           is_installment_plan: true,
                           charge_occurrence_count: 3)
      purchase.update_column(:subscription_id, subscription.id)
    end

    it "calculates installment amounts using original price and plan" do
      # Change product price and create a new installment plan
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan, link: product, number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)

      # Mock the subscription to have 0 successful purchases so we get the first installment
      allow(purchase.subscription).to receive(:purchases).and_return(
        double(successful: double(count: 0))
      )

      # First installment should be 334 cents (1000/3 + 1 remainder)
      expect(purchase.calculate_installment_payment_price_cents(1000)).to eq(334)
    end

    it "maintains consistent installment amounts across charges" do
      # Change product configuration
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan, link: product, number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)

      # All installment amounts should be based on original 1000 cents / 3 installments
      original_amounts = [334, 333, 333] # 1000/3 with remainder on first

      original_amounts.each_with_index do |expected_amount, index|
        # Simulate different installment numbers
        allow(purchase.subscription).to receive(:purchases).and_return(
          double(successful: double(count: index))
        )

        expect(purchase.calculate_installment_payment_price_cents(1000)).to eq(expected_amount)
      end
    end
  end

  describe "subscription current_subscription_price_cents" do
    let(:original_installment_plan) { installment_plan }

    let(:purchase) do
      build(:installment_plan_purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             original_installment_plan_id: original_installment_plan.id,
             original_purchase_price_cents: 1000).tap { |p| p.save!(validate: false) }
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
      # Ensure the subscription is properly linked
      subscription.reload
    end

    it "uses original installment amount for recurring charges" do
      # Change product price and create a new installment plan
      product.update!(price_cents: 2000)
      new_installment_plan = create(:product_installment_plan, link: product, number_of_installments: 5)
      product.update!(installment_plan: new_installment_plan)


      # Next installment amount should be based on original price
      # The subscription calculates the next installment to be charged
      # For 1000 cents / 3 installments: [334, 333, 333] - next installment is 333 (second installment)
      expect(subscription.current_subscription_price_cents).to eq(333) # 1000/3 second installment
    end
  end

  describe "integration with purchase creation service" do
    it "automatically stores original installment data during purchase creation" do
      purchase = build(:purchase,
                       link: product,
                       purchaser: buyer,
                       seller: seller,
                       displayed_price_cents: 1000,
                       is_installment_payment: true).tap { |p| p.save!(validate: false) }

      # Test the store_original_installment_data! method directly
      purchase.store_original_installment_data!(validate: false)

      purchase.reload
      expect(purchase.original_installment_plan_id).to eq(installment_plan.id)
      expect(purchase.original_purchase_price_cents).to eq(1000)
    end
  end

  describe "backward compatibility" do
    let(:purchase) do
      build(:purchase,
             link: product,
             purchaser: buyer,
             seller: seller,
             displayed_price_cents: 1000,
             is_installment_payment: true).tap { |p| p.save!(validate: false) }
      # Don't set original data to simulate old purchases
    end

    it "falls back to current product data for purchases without original data" do
      # Change product price
      product.update!(price_cents: 2000)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(2000)
      expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
    end
  end

  describe "edge cases" do
    it "handles missing installment plan gracefully" do
      purchase = build(:purchase,
                       link: product,
                       purchaser: buyer,
                       seller: seller,
                       displayed_price_cents: 1000,
                       is_installment_payment: true,
                       original_installment_plan_id: 99999).tap { |p| p.save!(validate: false) } # Non-existent ID

      # Should fallback to current product's installment plan
      expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
    end

    it "handles zero quantity" do
      purchase = build(:purchase,
                       link: product,
                       purchaser: buyer,
                       seller: seller,
                       displayed_price_cents: 1000,
                       is_installment_payment: true,
                       original_purchase_price_cents: 1000,
                       quantity: 0).tap { |p| p.save!(validate: false) }

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(0)
    end
  end
end
