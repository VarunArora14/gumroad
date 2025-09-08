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
                user.as_json(
                  internal_use: true,
                  methods: %i[
                    id
                    form_email
                    form_email_blocked_at
                    form_email_domain
                    form_email_domain_blocked_at
                    avatar_url
                    username
                    subdomain_with_protocol
                    support_email
                    custom_fee_per_thousand
                    has_payments
                    verified
                    deleted
                    all_adult_products
                    unpaid_balance_cents
                  ],
                  include: {
                    admin_manageable_user_memberships: {
                      include: {
                        seller: {
                          only: %i[id],
                          methods: %i[avatar_url display_name_or_email]
                        }
                      }
                    }
                  }
                ).merge(
                  impersonatable: policy([:admin, :impersonators, user]).create?,
                  compliant: user.compliant?,
                  suspended: user.suspended?,
                  unpaid_balance_cents: user.unpaid_balance_cents,
                  disable_paypal_sales: user.disable_paypal_sales?,
                  flagged_for_fraud: user.flagged_for_fraud?,
                  on_probation: user.on_probation?,
                  user_risk_state: user.user_risk_state.humanize
                )
             end
           )
  end

  private

    def set_users
      @users = User.refund_queue
                   .includes(:payments, :admin_manageable_user_memberships)
                   .with_blocked_attributes_for(:form_email, :form_email_domain)
    end
end
