import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import AdminAddCreditForm from "$app/components/Admin/Users/AddCredit/Form";

type AdminUserAddCreditProps = {
  user: User;
};

const AdminUserAddCredit = ({ user }: AdminUserAddCreditProps) => {
  return (
    <>
      <hr />
      <details>
        <summary>
          <h3>Add credits</h3>
        </summary>
        <AdminAddCreditForm user_id={user.id} />
      </details>
    </>
  );
};

export default AdminUserAddCredit;
