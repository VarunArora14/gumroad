# frozen_string_literal: true

class Admin::Users::BaseController < Admin::BaseController
  before_action :fetch_user

  protected

    def fetch_user
      @user = User.find_by(id: params[:user_id]) || e404
    end
end
