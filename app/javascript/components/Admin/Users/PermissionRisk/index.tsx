import React from "react";

import type { User } from "$app/components/Admin/Users/User";
import type { CurrentUser } from "$app/types/user";

import AdminUserPermissionRiskActions from "$app/components/Admin/Users/PermissionRisk/Actions";
import CompliantStatus from "$app/components/Admin/Users/PermissionRisk/CompliantStatus";
import FlagForFraud from "$app/components/Admin/Users/PermissionRisk/FlagForFraud";
import SuspendForFraud from "$app/components/Admin/Users/PermissionRisk/SuspendForFraud";

type AdminUserPermissionRiskProps = {
  user: User;
  current_user: CurrentUser;
};

const AdminUserPermissionRisk = ({ user, current_user }: AdminUserPermissionRiskProps) => current_user.has_risk_privilege && (
  <>
    <hr />

    <div className="flex justify-between">
      <AdminUserPermissionRiskActions user={user} />
      <CompliantStatus user={user} />
    </div>

    <FlagForFraud user={user} />
    <SuspendForFraud user={user} />
  </>
);


export default AdminUserPermissionRisk;
