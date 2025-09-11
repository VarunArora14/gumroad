import * as React from "react";

import { showAlert } from "$app/components/server-components/Alert";
import AdminPausePayoutsForm from "$app/components/Admin/Users/PayoutInfo/PausePayoutsForm";
import AdminResumePayoutsForm from "$app/components/Admin/Users/PayoutInfo/ResumePayoutsForm";

const AdminTogglePayoutsForm = ({
  user_id,
  payouts_paused_by,
  reason: currentReason,
}: {
  user_id: number;
  payouts_paused_by: "stripe" | "admin" | "system" | "user" | null;
  reason: string | null;
}) => {
  const [paused, setPaused] = React.useState(payouts_paused_by === "admin" || payouts_paused_by === "system" || payouts_paused_by === "stripe");
  const [reason, setReason] = React.useState(currentReason);

  const onPaused = (reason: string) => {
    setReason(reason);
    setPaused(true);
    showAlert("Payouts paused", "success");
  }

  const onResumed = () => {
    setPaused(false);
    showAlert("Payouts resumed", "success");
  }

  if (paused) {
    return <AdminResumePayoutsForm user_id={user_id} payouts_paused_by={payouts_paused_by} reason={reason} onSuccess={onResumed} />;
  } else {
    return <AdminPausePayoutsForm user_id={user_id} onSuccess={onPaused} />;
  }
};

export default AdminTogglePayoutsForm;
