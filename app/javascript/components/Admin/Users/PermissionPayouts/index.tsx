import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import AdminUserComplianceInfo from "$app/components/Admin/Users/ComplianceInfo";

type AdminUserPermissionPayoutsProps = {
  user: User;
};

const AdminUserPermissionPayouts = ({ user }: AdminUserPermissionPayoutsProps) => {
  return (
    <>
      <AdminUserComplianceInfo user={user} />
    </>
  )
}

export default AdminUserPermissionPayouts;
