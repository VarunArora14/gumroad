import * as React from "react";
import { createCast } from "ts-safe-cast";

import { register } from "$app/utils/serverComponentUtil";

import { Form } from "$app/components/Admin/Form";
import { showAlert } from "$app/components/server-components/Alert";

export const AdminPausePayoutsForm = ({
  user_id,
  payouts_paused_by_admin,
  payouts_paused_by_user,
}: {
  user_id: number;
  payouts_paused_by_admin: boolean;
  payouts_paused_by_user: boolean;
}) => {
  const admin_can_resume_payouts = payouts_paused_by_admin && !payouts_paused_by_user;

  return (
    <Form
      url={
        admin_can_resume_payouts
          ? Routes.resume_admin_user_payouts_path(user_id)
          : Routes.pause_admin_user_payouts_path(user_id)
      }
      method="POST"
      confirmMessage={`Are you sure you want to ${admin_can_resume_payouts ? "resume" : "pause"} payouts for user ${user_id}?`}
      onSuccess={() => showAlert(admin_can_resume_payouts ? "Payouts resumed" : "Payouts paused", "success")}
    >
      {(isLoading) => (
        <fieldset>
          <div className="input-with-button" style={{ alignItems: "end" }}>
            {payouts_paused_by_admin ? (
              <p>Payouts are currently paused by Gumroad.</p>
            ) : payouts_paused_by_user ? (
              <p>Payouts are currently paused by the creator.</p>
            ) : (
              <div style={{ display: "grid", gap: "var(--spacer-2)" }}>
                <textarea
                  name="pause_payouts[reason]"
                  rows={2}
                  placeholder="Add a reason for pausing payouts. It'll be displayed to the user on their dashboard."
                />
              </div>
            )}
            <button type="submit" className="button" disabled={isLoading}>
              {isLoading
                ? admin_can_resume_payouts
                  ? "Resuming Payouts"
                  : "Pausing Payouts"
                : admin_can_resume_payouts
                  ? "Resume Payouts"
                  : "Pause Payouts"}
            </button>
          </div>
        </fieldset>
      )}
    </Form>
  );
};

export default register({ component: AdminPausePayoutsForm, propParser: createCast() });
