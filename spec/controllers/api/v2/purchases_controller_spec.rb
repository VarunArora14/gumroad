# frozen_string_literal: true

require "spec_helper"

describe Api::V2::PurchasesController do
  let(:user) { create(:user) }
  let(:application) { create(:oauth_application, owner: user, scopes: "resend_receipt") }
  let(:token) { create(:oauth_access_token, application:, resource_owner_id: user.id, scopes: "resend_receipt") }
  let(:purchase) { create(:purchase, seller: user) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe "POST resend_receipt" do
    context "when the purchase exists" do
      it "resends the receipt" do
        expect_any_instance_of(Purchase).to receive(:resend_receipt)
        post :resend_receipt, params: { id: purchase.external_id }
        expect(response).to be_successful
        expect(json_response[:success]).to be true
      end
    end

    context "when the purchase does not exist" do
      it "returns a not found error" do
        post :resend_receipt, params: { id: "non-existent" }
        expect(response).to be_successful
        expect(json_response[:success]).to be false
        expect(json_response[:message]).to eq("The purchase was not found.")
      end
    end

    context "when the token does not have the required scope" do
      let(:token) { create(:oauth_access_token, application:, resource_owner_id: user.id, scopes: "view_sales") }

      it "returns an unauthorized error" do
        post :resend_receipt, params: { id: purchase.external_id }
        expect(response).to be_unauthorized
      end
    end

    context "when the purchase belongs to another user" do
      let(:other_user) { create(:user) }
      let(:other_purchase) { create(:purchase, seller: other_user) }

      it "returns a not found error" do
        post :resend_receipt, params: { id: other_purchase.external_id }
        expect(response).to be_successful
        expect(json_response[:success]).to be false
        expect(json_response[:message]).to eq("The purchase was not found.")
      end
    end
  end
end
