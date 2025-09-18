import React from "react";

import type { User } from "$app/components/Admin/Users/User";

import AdminMassTransferPurchasesForm from "$app/components/Admin/Users/MassTransferPurchases/Form";

type AdminUserMassTransferPurchasesProps = {
  user: User;
};

const AdminUserMassTransferPurchases = ({ user }: AdminUserMassTransferPurchasesProps) => (
  <>
    <hr />
    <details>
      <summary>
        <h3>Mass-transfer purchases</h3>
      </summary>
      <AdminMassTransferPurchasesForm user_id={user.id} />
    </details>
  </>
);

export default AdminUserMassTransferPurchases;
