# frozen_string_literal: true

class Admin::SuspendUsersController < Admin::BaseController
  # IDs can be separated by whitespaces or commas
  ID_DELIMITER_REGEX = /\s|,/

  layout "admin_inertia", only: :show

  def show
    render inertia: "Admin/SuspendUsers/Show",
           props: inertia_props(
              title: "Mass-suspend users",
              suspend_reasons: [
                "Violating our terms of service",
                "Creating products that violate our ToS",
                "Using Gumroad to commit fraud",
                "Using Gumroad for posting spam or SEO manipulation",
              ]
           )
  end

  def update
    user_ids = suspend_users_params[:identifiers].split(ID_DELIMITER_REGEX).select(&:present?)
    reason = suspend_users_params[:reason]
    additional_notes = suspend_users_params[:additional_notes].presence.try(:strip)

    SuspendUsersWorker.perform_async(current_user.id, user_ids, reason, additional_notes)

    redirect_to admin_suspend_users_url, notice: "User suspension in progress!", status: :see_other, inertia: {}
  end

  private

  def suspend_users_params
    params.require(:suspend_users).permit(:identifiers, :reason, :additional_notes)
  end
end
