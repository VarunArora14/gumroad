import React from "react";

import type { User } from "$app/components/Admin/Users/User";

type MembershipsProps = {
  user: User;
};

const Memberships = ({ user }: MembershipsProps) => {
  console.log(user);
  return <div>Memberships</div>;
};

export default Memberships;
