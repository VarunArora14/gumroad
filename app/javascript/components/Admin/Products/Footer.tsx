import React from "react";

import type { Product } from "$app/components/Admin/Products/Product";
import DateTimeWithRelativeTooltip from "$app/components/Admin/DateTimeWithRelativeTooltip";
import { NoIcon } from "$app/components/Icons";

type AdminProductFooterProps = {
  product: Product;
};

const AdminProductFooter = ({ product }: AdminProductFooterProps) => {
  return (
    <>
      <hr />
      <dl>
        <dt>Updated</dt>
        <dd><DateTimeWithRelativeTooltip date={product.updated_at} /></dd>
        <dt>Deleted</dt>
        <dd><DateTimeWithRelativeTooltip date={product.deleted_at} placeholder={<NoIcon />} /></dd>
      </dl>
    </>
  );
};

export default AdminProductFooter;
