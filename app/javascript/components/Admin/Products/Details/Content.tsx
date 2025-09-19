import React from "react";

import AdminProductAttributesAndInfo from "$app/components/Admin/Products/AttributesAndInfo";
import { type DetailsProps } from "$app/components/Admin/Products/AttributesAndInfo";

import Loading from "$app/components/Admin/Loading";

const AdminProductDetailsContent = ({ details, isLoading }: { details: DetailsProps; isLoading: boolean }) => {
  if (isLoading) return <Loading />;

  return <AdminProductAttributesAndInfo productData={details} />;
};

export default AdminProductDetailsContent;
