import React from "react";

import { type Product } from "$app/components/Admin/Products/Product";
import PublishAction from "$app/components/Admin/Products/Actions/PublishAction";
import DeleteAction from "$app/components/Admin/Products/Actions/DeleteAction";
import MakeAdultAction from "$app/components/Admin/Products/Actions/MakeAdultAction";
import MarkAsStaffPickedAction from "$app/components/Admin/Products/Actions/MarkAsStaffPickedAction";
import UnmarkAsStaffPickedAction from "$app/components/Admin/Products/Actions/UnmarkAsStaffPickedAction";
import JoinDiscordAction from "$app/components/Admin/Products/Actions/JoinDiscordAction";

type AdminProductActionsProps = {
  product: Product;
};

const AdminProductActions = ({ product }: AdminProductActionsProps) => {
  return (
    <>
    <hr />
    <div className="button-group">
      <PublishAction product={product} />
      <DeleteAction product={product} />
      <MakeAdultAction product={product} />
      <MarkAsStaffPickedAction product={product} />
      <UnmarkAsStaffPickedAction product={product} />
      <JoinDiscordAction product={product} />
    </div>
    </>
  );
};

export default AdminProductActions;
