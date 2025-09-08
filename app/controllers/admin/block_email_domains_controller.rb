# frozen_string_literal: true

class Admin::BlockEmailDomainsController < Admin::BaseController
  include MassBlocker
  layout "admin_inertia", only: :show

  def show
    render inertia: "Admin/BlockEmailDomains/Show", props: inertia_props(title: "Mass-block email domains")
  end

  def update
    schedule_mass_block(identifiers: email_domains_params[:identifiers], object_type: "email_domain")
    redirect_to admin_block_email_domains_url, notice: "Blocking email domains in progress!", status: :see_other, inertia: {}
  end

  private
    def email_domains_params
      params.require(:email_domains).permit(:identifiers)
    end
end
