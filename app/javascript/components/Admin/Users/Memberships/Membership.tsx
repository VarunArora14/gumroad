import React from "react";
import { Link } from "@inertiajs/react";
import DateTimeWithRelativeTooltip from "$app/components/Admin/DateTimeWithRelativeTooltip";

import type { UserMembership } from "$app/components/Admin/Users/User";

type MembershipProps = {
  membership: UserMembership;
};

const Membership = ({ membership }: MembershipProps) => {
  return (
    <div>
      <div className="flex gap-4 items-center">
        <img src={membership.seller.avatar_url} className="user-avatar" alt={membership.seller.display_name_or_email} />
        <div className="grid">
          <h5><Link href={Routes.admin_user_url(membership.seller.id)}>{membership.seller.display_name_or_email}</Link></h5>
          <div className="small">{membership.role}</div>
        </div>
      </div>
      <div className="text-right">
        {membership.last_accessed_at && (
          <div className="small">
            last accessed
            <DateTimeWithRelativeTooltip date={membership.last_accessed_at} />
          </div>
        )}
      </div>
      <div className="small">
        invited
        <DateTimeWithRelativeTooltip date={membership.created_at} />
      </div>
    </div>

  )
};

export default Membership;
