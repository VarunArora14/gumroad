import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import ImpersonateAction from "$app/components/Admin/Users/Actions/ImpersonateAction";
import VerifyAction from "$app/components/Admin/Users/Actions/VerifyAction";
import UndeleteAction from "$app/components/Admin/Users/Actions/UndeleteAction";
import ResetPasswordAction from "$app/components/Admin/Users/Actions/ResetPasswordAction";
import ConfirmEmailAction from "$app/components/Admin/Users/Actions/ConfirmEmailAction";
import InvalidateActiveSessionsAction from "$app/components/Admin/Users/Actions/InvalidateActiveSessionsAction";
import MarkAsAdultAction from "$app/components/Admin/Users/Actions/MarkAsAdultAction";

type AdminUserActionsProps = {
  user: User;
};

const AdminUserActions = ({ user }: AdminUserActionsProps) => {
  return (
    <div className="button-group">
      <ImpersonateAction user={user} />
      <VerifyAction user={user}/>
      <UndeleteAction user={user}/>
      <ResetPasswordAction user={user}/>
      <ConfirmEmailAction user={user}/>
      <InvalidateActiveSessionsAction user={user}/>
      <MarkAsAdultAction user={user}/>
    </div>
  )
};

export default AdminUserActions;

{/* <div class="button-group">
    <% can_impersonate = policy([:admin, :impersonators, user]).create? %>
    <% if can_impersonate %>
      <%= link_to "Become", admin_impersonate_path(user_identifier: user.external_id), class: "button small" %>
    <% else %>
      <%= with_tooltip(tip: "User is either deleted, or a team member.") do %>
        <%= link_to "Become", "#", class: "button small", disabled: true %>
      <% end %>
    <% end %>
    <%= admin_action label: (user.verified? ? "Unverify" : "Verify"), url: verify_admin_user_path(user), confirm_message: "Are you sure you want to (un)verify user #{user.id}?", done: user.verified? ? "Verify" : "Unverify", success_message: user.verified? ? "Unverified." : "Verified." %>

    <% if user.deleted? %>
      <%= admin_action label: "Undelete", url: enable_admin_user_path(user), confirm_message: "Are you sure you want to undelete the account of user #{user.id}?", done: "Undeleted.", success_message: "Undeleted" %>
    <% end %>

    <%= admin_action label: "Reset password", url: reset_password_admin_user_path(user), confirm_message: "Are you sure you want to reset the password of user #{user.id}?", loading: "Resetting...", done: "Password reset.", show_message_in_alert: true %>
    <%= admin_action label: "Confirm email", url: confirm_email_admin_user_path(user), confirm_message: "Are you sure you want to confirm the email address for #{user.id}?", success_message: "Confirmed email.", done: "Confirmed email." %>
    <%= admin_action label: "Sign out from all active sessions", url: invalidate_active_sessions_admin_user_path(user), confirm_message: "Are you sure you want to sign out user #{user.id} from all active sessions?", loading: "Signing out from all active sessions...", success_message: "Signed out from all active sessions", done: "Signed out from all active sessions" %>
    <%= admin_action label: (user.all_adult_products? ? "Unmark as adult" : "Mark as adult"), url: toggle_adult_products_admin_user_path(user), confirm_message: "Are you sure you want to #{user.all_adult_products? ? 'unmark' : 'mark'} user #{user.id} as adult?", done: (user.all_adult_products? ? "Mark as adult" : "Unmark as adult"), success_message: (user.all_adult_products? ? "Unmarked as adult." : "Marked as adult.") %>
  </div> */}
