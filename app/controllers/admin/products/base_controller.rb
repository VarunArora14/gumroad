# frozen_string_literal: true

class Admin::Products::BaseController < Admin::BaseController
  include Admin::FetchProduct

  before_action :fetch_product
end
