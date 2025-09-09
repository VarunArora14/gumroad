# frozen_string_literal: true

module Admin::FetchUser
  private

    def fetch_user
      @user = if user_param.include?("@")
        User.find_by(email: user_param)
      else
        User.find_by(username: user_param) ||
          User.find_by(id: user_param) ||
          User.find_by(external_id: user_param)
      end

      e404 unless @user
    end

    def user_param
      params[:id]
    end
end
