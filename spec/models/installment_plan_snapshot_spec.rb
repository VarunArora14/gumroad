# frozen_string_literal: true

require "spec_helper"

describe Purchase, :vcr do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product, user: seller, price_cents: 15000, native_type: Link::NATIVE_TYPE_DIGITAL) }
  let(:installment_plan) { create(:product_installment_plan, link: product, number_of_installments: 3, recurrence: "monthly") }

  before do
    product.installment_plan = installment_plan
    product.save!
  end

  describe "installment plan snapshotting" do
    describe "#capture_installment_plan_snapshot" do
      context "when purchase is an installment payment" do
        let(:subscription) { create(:subscription, is_installment_plan: true, user: buyer, link: product) }
        let(:payment_option) { create(:payment_option, subscription: subscription, installment_plan: installment_plan, price: create(:price, link: product)) }

        before do
          subscription.update!(last_payment_option: payment_option)
        end

        it "captures installment plan snapshot data" do
          purchase = Purchase.new(
            link: product,
            subscription: subscription,
            price_cents: 15000,
            is_installment_payment: true
          )

          purchase.send(:capture_installment_plan_snapshot)

          expect(purchase.installment_plan_id).to eq(installment_plan.id)
          expect(purchase.installment_number_of_installments).to eq(3)
          expect(purchase.installment_payment_amounts_cents).to be_present

          amounts = JSON.parse(purchase.installment_payment_amounts_cents)
          expect(amounts).to eq([5000, 5000, 5000]) # $150 / 3 = $50 each
        end

        it "handles remainder correctly in payment amounts" do
          purchase = Purchase.new(
            link: product,
            subscription: subscription,
            price_cents: 15100, # $151 not evenly divisible by 3
            is_installment_payment: true
          )

          purchase.send(:capture_installment_plan_snapshot)

          amounts = JSON.parse(purchase.installment_payment_amounts_cents)
          expect(amounts).to eq([5034, 5033, 5033]) # First payment gets remainder
        end
      end

      context "when purchase is not an installment payment" do
        it "does not capture data" do
          purchase = Purchase.new(
            link: product,
            price_cents: 15000,
            is_installment_payment: false
          )

          purchase.send(:capture_installment_plan_snapshot)

          expect(purchase.installment_plan_id).to be_nil
          expect(purchase.installment_number_of_installments).to be_nil
          expect(purchase.installment_payment_amounts_cents).to be_nil
        end
      end
    end

    describe "#fetch_installment_plan" do
      context "when snapshot data is available" do
        it "uses snapshot installment plan" do
          purchase = build(:purchase, installment_plan_id: installment_plan.id)
          # Manually set the association since build doesn't load it
          purchase.installment_plan = installment_plan

          expect(purchase.send(:fetch_installment_plan)).to eq(installment_plan)
        end
      end

      context "when no snapshot data is available" do
        it "falls back to subscription installment plan" do
          subscription = create(:subscription, is_installment_plan: true, user: buyer, link: product)
          payment_option = create(:payment_option, subscription: subscription, installment_plan: installment_plan, price: create(:price, link: product))
          subscription.update!(last_payment_option: payment_option)

          purchase = Purchase.new(subscription: subscription, installment_plan_id: nil)

          expect(purchase.send(:fetch_installment_plan)).to eq(installment_plan)
        end
      end
    end

    describe "#calculate_installment_payment_price_cents" do
      context "when snapshot data is available" do
        it "uses snapshot data" do
          subscription = create(:subscription, is_installment_plan: true, user: buyer, link: product)

          purchase = Purchase.new(
            subscription: subscription,
            installment_payment_amounts_cents: [5000, 5000, 5000].to_json,
            is_installment_payment: true
          )

          # Mock subscription to return count for nth installment
          allow(subscription).to receive_message_chain(:purchases, :successful, :count).and_return(0)

          result = purchase.send(:calculate_installment_payment_price_cents, 15000)
          expect(result).to eq(5000) # First installment from snapshot
        end
      end

      context "when no snapshot data is available" do
        it "falls back to current plan" do
          subscription = create(:subscription, is_installment_plan: true, user: buyer, link: product)
          payment_option = create(:payment_option, subscription: subscription, installment_plan: installment_plan, price: create(:price, link: product))
          subscription.update!(last_payment_option: payment_option)

          purchase = Purchase.new(
            subscription: subscription,
            installment_payment_amounts_cents: nil,
            is_installment_payment: true
          )

          # Mock subscription to return count for nth installment
          allow(subscription).to receive_message_chain(:purchases, :successful, :count).and_return(0)

          result = purchase.send(:calculate_installment_payment_price_cents, 15000)
          expect(result).to eq(5000) # Falls back to current plan calculation
        end
      end
    end
  end
end
