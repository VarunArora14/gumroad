import { usePage } from "@inertiajs/react";
import React from "react";

import AdminProductHeader from "$app/components/Admin/Products/Header";
import AdminProductDescription from "$app/components/Admin/Products/Description";
import AdminProductDetails from "$app/components/Admin/Products/Details";
import AdminProductInfo from "$app/components/Admin/Products/Info";

type ProductFile = {
  id: number;
  external_id: string;
  s3_filename: string;
};

export type Product = {
  id: number;
  name: string;
  price_cents: number;
  currency_code: string;
  unique_permalink: string;
  preview_url: string;
  cover_placeholder_url: string;
  price_formatted: string;
  created_at: string;
  user_name: string;
  user_id: string;
  admins_can_generate_url_redirects: boolean;
  alive_product_files: ProductFile[];
  stripped_html_safe_description: string;
};

const AdminUsersProductsProduct = ({ product }: { product: Product }) => {
  const { url } = usePage();
  const isCurrentUrl = url === Routes.admin_link_url(product.id);

  return (
    <article className="card" data-product-id={product.unique_permalink}>
      <AdminProductHeader product={product} isCurrentUrl={isCurrentUrl} />
      <AdminProductDescription product={product} />
      <AdminProductDetails product={product} />
      <AdminProductInfo product={product} />
    </article>
  );
};

export default AdminUsersProductsProduct;
