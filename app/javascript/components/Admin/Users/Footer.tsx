import React from "react";
import DateTimeWithRelativeTooltip from "$app/components/Admin/DateTimeWithRelativeTooltip";
import { NoIcon } from "$app/components/Icons";
import type { User } from "$app/components/Admin/Users/User";


type FooterProps = {
  user: User;
};

const Footer = ({ user }: FooterProps) => {
  return <div>
    <dl>
      <dt>Created</dt>
      <dd><DateTimeWithRelativeTooltip date={user.created_at} /></dd>
      <dt>Updated</dt>
      <dd><DateTimeWithRelativeTooltip date={user.updated_at} /></dd>
      <dt>Deleted</dt>
      <dd><DateTimeWithRelativeTooltip date={user.deleted_at} placeholder={<NoIcon />} /></dd>
    </dl>
  </div>;
};

export default Footer;
