# frozen_string_literal: true

class Admin::RefundQueuesController < Admin::BaseController
  layout "admin_inertia"

  before_action :set_users

  def show
    # TODO: refactor this
    render  inertia: "Admin/RefundQueues/Show",
            props: inertia_props(
              title: "Refund queue",
              users: @users.map do |user|
                user.as_json_for_admin(
                  impersonatable: policy([:admin, :impersonators, user]).create?
                )
              end
            )
  end

  private

    def set_users
      @users = User.refund_queue
                   .includes(
                     :admin_manageable_user_memberships,
                     :payments
                   )
                   .with_blocked_attributes_for(:form_email, :form_email_domain)
    end
end
