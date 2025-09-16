import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import AdminChangeEmailForm from "$app/components/Admin/Users/ChangeEmail/Form";

type AdminUserChangeEmailProps = {
  user: User;
};

const AdminUserChangeEmail = ({ user }: AdminUserChangeEmailProps) => {
  return (
    <>
      <hr />
      <details>
        <summary>
          <h3>Change email</h3>
        </summary>
        <AdminChangeEmailForm user_id={user.id} current_email={user.email} />
      </details>
    </>
  );
};

export default AdminUserChangeEmail;
