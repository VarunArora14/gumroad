# frozen_string_literal: true

class Admin::Products::PurchasesController < Admin::Products::BaseController
  include Pagy::Backend

  def index
    pagy, purchases = pagy_countless(
      Purchase.for_admin_listing.includes(:subscription, :price, :refunds),
      limit: params[:per_page],
      page: params[:page]
    )

    render json: {
      purchases: purchases.as_json(admin_review: true),
      pagination: pagy
    }
  end
end
