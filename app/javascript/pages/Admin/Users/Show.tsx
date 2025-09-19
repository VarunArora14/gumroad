import React from "react";
import { usePage } from '@inertiajs/react';
import User, { type User as UserType } from "$app/components/Admin/Users/User";
import AdminUserAndProductsTabs from "$app/components/Admin/UserAndProductsTabs";

type Props = {
  user: UserType;
};

const AdminUsersShow = () => {
  const { user } = usePage().props as unknown as Props;

  return (
    <div className="paragraphs">
      <AdminUserAndProductsTabs selectedTab="users" user={user} />
      <User user={user} is_affiliate_user={false} />
    </div>
  );
};

export default AdminUsersShow;
