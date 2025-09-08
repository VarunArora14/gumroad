import React from "react";

import type { User } from "$app/components/Admin/Users/User";
import AdminAction from "$app/components/Admin/ActionButton";

type MarkCompliantActionProps = {
  user: User;
};

const MarkCompliantAction = ({ user }: MarkCompliantActionProps) => !user.compliant && (
  <AdminAction
    label="Mark compliant"
    url={Routes.mark_compliant_admin_user_path(user.id)}
    loading="Marking compliant..."
    done="Marked compliant"
    success_message="Marked compliant!"
    outline
    color="success"
  />
);

export default MarkCompliantAction;
