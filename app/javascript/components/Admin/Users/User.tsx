import React from "react";
import { usePage } from "@inertiajs/react";
import Header from "$app/components/Admin/Users/Header";
import AdminUserActions from "$app/components/Admin/Users/Actions";
import AdminUserMemberships from "$app/components/Admin/Users/Memberships";
import AdminUserPermissionRisk from "$app/components/Admin/Users/PermissionRisk";
import AdminUserComplianceInfo from "$app/components/Admin/Users/ComplianceInfo";
import AdminUserPayoutInfo from "$app/components/Admin/Users/PayoutInfo";
import AdminUserMerchantAccounts from "$app/components/Admin/Users/MerchantAccounts";
import AdminUserEmailChanges from "$app/components/Admin/Users/EmailChanges";
import AdminUserChangeEmail from "$app/components/Admin/Users/ChangeEmail";
import AdminUserCustomFee from "$app/components/Admin/Users/CustomFee";
import AdminUserAddCredit from "$app/components/Admin/Users/AddCredit";
import AdminUserMassTransferPurchases from "$app/components/Admin/Users/MassTransferPurchases";
import AdminUserComments from "$app/components/Admin/Users/Comments";
import Footer from "$app/components/Admin/Users/Footer";

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
  updated_at: string;
  deleted_at: string;
};

export type Props = {
  user: User;
  is_affiliate_user: boolean;
};

const User = ({ user, is_affiliate_user }: Props) => {
  const { url } = usePage() as unknown as { url: string };

  return (
    <div className="card js-admin-user" data-user-id={user.id}>
      <Header user={user} is_affiliate_user={is_affiliate_user} url={url} />

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
      <AdminUserAddCredit user={user} />
      <AdminUserMassTransferPurchases user={user} />
      <AdminUserComments user={user} />

      <hr />

      <Footer user={user} />
    </div>
  );
}

export default User;
