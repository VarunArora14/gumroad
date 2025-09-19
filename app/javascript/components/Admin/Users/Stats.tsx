import * as React from "react";

import { request, assertResponseError } from "$app/utils/request";

import { showAlert } from "$app/components/server-components/Alert";
import { useRunOnce } from "$app/components/useRunOnce";

import Loading from "$app/components/Admin/Loading";

type UserStatsProps = {
  total: string;
  balance: string;
  chargeback_volume: string;
  chargeback_count: string;
};

const AdminUserStats = ({ user_id }: { user_id: number }) => {
  const [userStats, setUserStats] = React.useState<UserStatsProps | null>(null);

  useRunOnce(() => {
    const fetchUserStats = async () => {
      try {
        const response = await request({
          method: "GET",
          url: Routes.admin_user_stats_path(user_id),
          accept: "json",
        });
        if (!response.ok) assertResponseError(response);
        const userStats: UserStatsProps = await response.json();
        setUserStats(userStats);
      } catch (e) {
        assertResponseError(e);
        showAlert(e.message, "error");
      }
    };

    fetchUserStats();
  });

  return userStats ? (
    <ul className="inline">
      <li>{userStats.total} total</li>
      <li>{userStats.balance} balance</li>
      <li>{userStats.chargeback_volume} vol CB</li>
      <li>{userStats.chargeback_count} count CB</li>
    </ul>
  ) : (
    <Loading />
  );
};

export default AdminUserStats;
