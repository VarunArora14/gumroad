# frozen_string_literal: true

class Admin::Users::ProductsController < Admin::Users::BaseController
  include Pagy::Backend
  helper Pagy::UrlHelpers

  before_action :fetch_user

  PRODUCTS_ORDER = "ISNULL(COALESCE(purchase_disabled_at, banned_at, links.deleted_at)) DESC, created_at DESC"
  PRODUCTS_PER_PAGE = 10

  def index
    pagy, products = pagy(@user.links.order(Arel.sql(PRODUCTS_ORDER)), limit: PRODUCTS_PER_PAGE)

    render inertia: "Admin/Users/Products/Index", props: inertia_props(
      title: "#{@user.display_name} on Gumroad",
      user: @user.as_json(methods: %i[display_name]),
      products: products.includes(:alive_product_files)
                         .as_json(
                           original: true,
                           methods: %i[admins_can_generate_url_redirects stripped_html_safe_description],
                           include: {
                            alive_product_files: {
                              original: true,
                              methods: %i[external_id s3_filename]
                            }
                          }
                         ),
      pagy:
    )
  end
end
