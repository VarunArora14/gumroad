import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import MarkCompliantAction from "$app/components/Admin/Users/PermissionRisk/Actions/MarkCompliantAction";
import RefundBalanceAction from "$app/components/Admin/Users/PermissionRisk/Actions/RefundBalanceAction";
import DisablePaypalSalesAction from "$app/components/Admin/Users/PermissionRisk/Actions/DisablePaypalSalesAction";

type AdminUserPermissionRiskActionsProps = {
  user: User;
};

const AdminUserPermissionRiskActions = ({ user }: AdminUserPermissionRiskActionsProps) => (
  <div className="button-group">
    <MarkCompliantAction user={user} />
    <RefundBalanceAction user={user} />
    <DisablePaypalSalesAction user={user} />
  </div>
)

export default AdminUserPermissionRiskActions;
