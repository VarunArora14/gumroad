import React from "react";
import { Link } from "@inertiajs/react";
import { type User as UserType } from "$app/components/Admin/Users/User";
import TabList from "$app/components/Tabs/TabList";
import Tab from "$app/components/Tabs/Tab";

const AdminUserAndProductsTabs = ({ selectedTab, user }: { selectedTab: string; user: UserType }) => {
  return (
    <TabList>
      <Tab isSelected={selectedTab === "users"}>
        <Link href={Routes.admin_user_path(user.id)} prefetch={true} className="block p-3 no-underline">Profile</Link>
      </Tab>
      <Tab isSelected={selectedTab === "products"}>
        <Link href={Routes.admin_user_products_path(user.id)} prefetch={true} className="block p-3 no-underline">Products</Link>
      </Tab>
    </TabList>
  );
};

export default AdminUserAndProductsTabs;
