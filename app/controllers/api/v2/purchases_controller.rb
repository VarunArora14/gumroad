# frozen_string_literal: true

class Api::V2::PurchasesController < Api::V2::BaseController
  before_action -> { doorkeeper_authorize!(:resend_receipt) }
  before_action :fetch_purchase, only: [:resend_receipt]

  RESEND_RECEIPT_OPENAPI = {
    summary: "Resend receipt",
    description: "Resend the purchase receipt to the customer's email",
    parameters: [
      {
        name: "id",
        in: "path",
        required: true,
        schema: {
          type: "string"
        },
        description: "The external ID of the purchase"
      }
    ],
    responses: {
      '200': {
        description: "Receipt resent successfully",
        content: {
          'application/json': {
            schema: {
              type: "object",
              properties: {
                success: { const: true }
              }
            }
          }
        }
      },
      '404': {
        description: "Purchase not found",
        content: {
          'application/json': {
            schema: {
              type: "object",
              properties: {
                success: { const: false },
                message: { type: "string" }
              }
            }
          }
        }
      }
    }
  }.freeze

  def resend_receipt
    if @purchase
      @purchase.resend_receipt
      success_with_resend_receipt
    else
      error_with_purchase
    end
  end

  private
    def success_with_resend_receipt
      success_with_object(:resend_receipt, nil)
    end

    def error_with_purchase(purchase = nil)
      error_with_object(:purchase, purchase)
    end

    def fetch_purchase
      @purchase = current_resource_owner.purchases.find_by_external_id(params[:id])
    end
end
