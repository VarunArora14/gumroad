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
