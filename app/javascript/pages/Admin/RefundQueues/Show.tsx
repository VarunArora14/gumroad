import React from "react";
import { usePage } from '@inertiajs/react';
import RefundableUser, { type User } from "$app/components/Admin/Users/User";
import EmptyState from "$app/components/Admin/EmptyState";

type Props = {
  users: User[];
};

const AdminRefundQueue = () => {
  const { users } = usePage().props as unknown as Props;

  return (
    <section className="flex flex-col gap-4">
      {users.map((user) => (
        <RefundableUser key={user.id} user={user} is_affiliate_user={false} />
      ))}
      {users.length === 0 && (
        <EmptyState message="No users found." />
      )}
    </section>
  );
};

export default AdminRefundQueue;
