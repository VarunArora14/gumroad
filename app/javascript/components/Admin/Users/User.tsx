import React from "react";
import { Link, usePage } from "@inertiajs/react";
import { classNames } from "$app/utils/classNames";
import { CopyToClipboard } from "$app/components/CopyToClipboard";
import { WithTooltip } from "$app/components/WithTooltip";
import { Icon } from "$app/components/Icons";
import DateTimeWithRelativeTooltip from "$app/components/Admin/DateTimeWithRelativeTooltip";
import BlockedUserTooltip from "$app/components/Admin/Users/BlockedUserTooltip";
import AdminUserStats from "$app/components/Admin/Users/Stats";
import AdminUserActions from "$app/components/Admin/Users/Actions";
import AdminUserMemberships from "$app/components/Admin/Users/Memberships";
import AdminUserPermissionRisk from "$app/components/Admin/Users/PermissionRisk";
import AdminUserComplianceInfo from "$app/components/Admin/Users/ComplianceInfo";
import AdminUserPayoutInfo from "$app/components/Admin/Users/PayoutInfo";
import AdminUserMerchantAccounts from "$app/components/Admin/Users/MerchantAccounts";
import AdminUserEmailChanges from "$app/components/Admin/Users/EmailChanges";
import AdminUserChangeEmail from "$app/components/Admin/Users/ChangeEmail";
import AdminUserCustomFee from "$app/components/Admin/Users/CustomFee";

export type Seller = {
  id: number;
  display_name_or_email: string;
  avatar_url: string;
};

export type UserMembership = {
  id: number;
  seller: Seller;
  role: string;
  last_accessed_at: string;
  created_at: string;
};

export type User = {
  id: number;
  email: string;
  support_email?: string;
  name: string;
  avatar_url: string;
  username: string;
  profile_url: string;
  form_email: string;
  form_email_blocked_at: string;
  form_email_domain: string;
  form_email_domain_blocked_at: string;
  subdomain_with_protocol: string;
  custom_fee_percent: number | null;
  has_payments: boolean;
  impersonatable: boolean;
  verified: boolean;
  deleted: boolean;
  all_adult_products: boolean;
  admin_manageable_user_memberships: UserMembership[];\
  compliant: boolean;
  suspended: boolean;
  unpaid_balance_cents: number;
  disable_paypal_sales: boolean;
  flagged_for_fraud: boolean;
  on_probation: boolean;
  user_risk_state: string;
  bio: string;
  created_at: string;
};

export type Props = {
  user: User;
  is_affiliate_user: boolean;
};

const User = ({ user, is_affiliate_user }: Props) => {
  const { url } = usePage() as unknown as { url: string };

  const displayName = user.name || `User ${user.username}`;
  const adminUserUrl = is_affiliate_user ? Routes.admin_affiliate_url(user.id) : Routes.admin_user_url(user.id);

  return (
    <div className="card js-admin-user" data-user-id={user.id}>
      <div className="paragraphs">
        <div className="flex gap-4 items-center">
          <img src={user.avatar_url} className="user-avatar" style={{ width: "var(--form-element-height)" }} alt={user.name} />
          <div className="grid gap-2">
            <h2>
              <Link href={adminUserUrl} className={classNames({ "active": url === adminUserUrl })}>{displayName}</Link>
            </h2>
            <ul className="inline">
            <li><DateTimeWithRelativeTooltip date={user.created_at} /></li>
              {user.username && (
                <li>
                  <Link href={user.subdomain_with_protocol} target="_blank" rel="noopener noreferrer nofollow">{user.username}</Link>
                </li>
              )}
              {user.form_email && (
                <li className="space-x-1">
                  <span>Email: {user.form_email}</span>
                  <CopyToClipboard tooltipPosition="bottom" copyTooltip="Copy email" text={user.form_email}>
                    <Icon name="outline-duplicate" />
                  </CopyToClipboard>
                  <BlockedUserTooltip user={user} position="bottom" />
                </li>
              )}
              {user.support_email && (
                <li className="space-x-1">
                  <span>Support email: {user.support_email}</span>
                  <CopyToClipboard tooltipPosition="bottom" copyTooltip="Copy support email" text={user.support_email}>
                    <Icon name="outline-duplicate" />
                  </CopyToClipboard>
                </li>
              )}
              {user.custom_fee_percent && (
                <li>
                  <WithTooltip tip="Custom fee that will be charged on all their new direct (non-discover) sales" position="bottom">
                    <span>Custom fee: {user.custom_fee_percent}%</span>
                  </WithTooltip>
                </li>
              )}
              {user.has_payments && (
                <li>
                  <Link href={Routes.admin_user_payouts_url(user)}>Payouts</Link>
                </li>
              )}
            </ul>

            <AdminUserStats user_id={user.id} />
          </div>
        </div>
      </div>

      <hr />

      <AdminUserActions user={user} />
      <AdminUserMemberships user={user} />
      <AdminUserPermissionRisk user={user} />
      <AdminUserComplianceInfo user={user} />
      <AdminUserPayoutInfo user={user} />
      <AdminUserMerchantAccounts user={user} />
      <AdminUserEmailChanges user={user} />
      <AdminUserChangeEmail user={user} />
      <AdminUserCustomFee user={user} />
    </div>
  );
}

export default User;
