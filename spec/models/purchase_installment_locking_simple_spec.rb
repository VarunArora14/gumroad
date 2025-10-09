# frozen_string_literal: true

require "spec_helper"

describe Purchase do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product, :with_installment_plan, user: seller, price_cents: 1000) }
  let(:installment_plan) { product.installment_plan }

  describe "#store_original_installment_data!" do
    context "when purchase is installment payment" do
      let(:purchase) { create(:installment_plan_purchase, link: product, purchaser: buyer) }

      it "stores installment plan id and original price" do
        purchase.store_original_installment_data!
        purchase.reload

        expect(purchase.original_installment_plan_id).to eq(installment_plan.id)
        expect(purchase.original_purchase_price_cents).to eq(1000)
      end
    end

    context "when purchase is not installment payment" do
      let(:purchase) { create(:purchase, link: product, purchaser: buyer) }

      it "does not store installment data" do
        purchase.store_original_installment_data!
        purchase.reload

        expect(purchase.original_installment_plan_id).to be_nil
        expect(purchase.original_purchase_price_cents).to be_nil
      end
    end
  end

  describe "#fetch_installment_plan" do
    context "when original installment plan exists" do
      let(:purchase) do
        create(:installment_plan_purchase,
               link: product,
               purchaser: buyer,
               original_installment_plan_id: installment_plan.id)
      end

      it "returns original installment plan" do
        expect(purchase.fetch_installment_plan).to eq(installment_plan)
      end
    end

    context "when original installment plan does not exist" do
      let(:purchase) { create(:installment_plan_purchase, link: product, purchaser: buyer) }

      it "returns current product installment plan" do
        expect(purchase.fetch_installment_plan).to eq(product.installment_plan)
      end
    end
  end

  describe "#minimum_paid_price_cents_per_unit_before_discount" do
    context "when purchase is installment payment" do
      let(:purchase) do
        create(:installment_plan_purchase,
               link: product,
               purchaser: buyer,
               original_purchase_price_cents: 1000,
               quantity: 1)
      end

      it "returns original purchase price when product price changes" do
        product.update!(price_cents: 2000)

        expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(1000)
      end
    end

    context "when purchase is not installment payment" do
      let(:purchase) { create(:purchase, link: product, purchaser: buyer, quantity: 1) }

      it "returns current product price when product price changes" do
        product.update!(price_cents: 2000)

        expect(purchase.minimum_paid_price_cents_per_unit_before_discount).to eq(2000)
      end
    end
  end
end
