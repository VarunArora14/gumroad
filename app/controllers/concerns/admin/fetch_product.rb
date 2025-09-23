module Admin::FetchProduct
  private

    def fetch_product
      @product = Link.find(params[:product_id])
    end
end
