import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import AdminUserPermissionRiskActions from "$app/components/Admin/Users/PermissionRisk/Actions";
import CompliantStatus from "$app/components/Admin/Users/PermissionRisk/CompliantStatus";
import FlagForFraud from "$app/components/Admin/Users/PermissionRisk/FlagForFraud";
import SuspendForFraud from "$app/components/Admin/Users/PermissionRisk/SuspendForFraud";
import UserGuids from "$app/components/Admin/Users/PermissionRisk/Guids";
import Bio from "$app/components/Admin/Users/PermissionRisk/Bio";
import LatestPosts from "$app/components/Admin/Users/PermissionRisk/LatestPosts";

type AdminUserPermissionRiskProps = {
  user: User;
};

const AdminUserPermissionRisk = ({ user }: AdminUserPermissionRiskProps) => (
  <>
    <hr />

    <div className="flex justify-between">
      <AdminUserPermissionRiskActions user={user} />
      <CompliantStatus user={user} />
    </div>

    <FlagForFraud user={user} />
    <SuspendForFraud user={user} />
    <UserGuids user_id={user.id} />
    <Bio user={user} />
    <LatestPosts user={user} />
  </>
);


export default AdminUserPermissionRisk;
