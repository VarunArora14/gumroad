# frozen_string_literal: true

class Admin::Products::InfosController < Admin::Products::BaseController
  include AdminHelper

  def show
    render json: {
      info: @product.as_json(
        original: true,
        only: %i[
          purchase_type
        ],
        methods: %i[
          external_id
          alive
          recommendable
          staff_picked
          is_in_preorder_state
          has_stampable_pdfs
          streamable
          is_physical
          is_licensed
          is_adult
          user_all_adult_products
          has_adult_keywords
        ],
        include: {
          tags: { methods: :humanized_name },
          active_integrations: { only: :type }
        }
      ).merge(
        taxonomy: @product.taxonomy.as_json(methods: :ancestry_path),
        type: product_type_label(@product),
        formatted_rental_price_cents: MoneyFormatter.format(@product.rental_price_cents, @product.price_currency_type.to_sym, no_cents_if_whole: true, symbol: true),
      )
    }
  end
end
