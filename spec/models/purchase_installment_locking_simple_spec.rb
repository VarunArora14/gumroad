# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Purchase Installment Locking - Simple Tests", type: :model do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product, user: seller, price_cents: 1000) }
  let(:installment_plan) { create(:product_installment_plan, link: product, number_of_installments: 3) }

  before do
    product.installment_plan = installment_plan
    product.save!
  end

  describe "store_original_installment_data!" do
    it "stores original installment plan data" do
      # Create a purchase manually to avoid validation issues
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful"
      )
      purchase.is_installment_payment = true
      purchase.save!(validate: false)

      # Ensure the product has the installment plan
      product.reload

      expect(purchase.is_installment_payment?).to be true
      expect(purchase.link.installment_plan).to eq(installment_plan)

      purchase.store_original_installment_data!(validate: false)
      purchase.reload

      expect(purchase.original_installment_plan_id).to eq(installment_plan.id)
      expect(purchase.original_purchase_price_cents).to eq(1000)
    end

    it "does not store data for non-installment purchases" do
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful"
      )
      # Don't set is_installment_payment flag
      purchase.save!(validate: false)

      purchase.store_original_installment_data!

      expect(purchase.original_installment_plan_id).to be_nil
      expect(purchase.original_purchase_price_cents).to be_nil
    end
  end

  describe "fetch_installment_plan" do
    it "uses original installment plan when available" do
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful",
        original_installment_plan_id: installment_plan.id
      )
      purchase.is_installment_payment = true
      purchase.save!(validate: false)

      expect(purchase.fetch_installment_plan).to eq(installment_plan)
    end

    it "falls back to current product installment plan when original is not available" do
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful"
      )
      purchase.is_installment_payment = true
      purchase.save!(validate: false)

      expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
    end
  end

  describe "minimum_paid_price_cents_per_unit_before_discount" do
    it "uses original purchase price for installment purchases" do
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful",
        original_purchase_price_cents: 1000,
        quantity: 1
      )
      purchase.is_installment_payment = true
      purchase.save!(validate: false)

      # Change the product price
      product.update!(price_cents: 2000)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(1000)
    end

    it "uses current product price for non-installment purchases" do
      purchase = Purchase.new(
        link: product,
        purchaser: buyer,
        seller: seller,
        displayed_price_cents: 1000,
        price_cents: 1000,
        total_transaction_cents: 1000,
        email: "test@example.com",
        purchase_state: "successful"
      )
      # Don't set is_installment_payment flag
      purchase.save!(validate: false)

      # Change the product price
      product.update!(price_cents: 2000)

      expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(2000)
    end
  end
end
