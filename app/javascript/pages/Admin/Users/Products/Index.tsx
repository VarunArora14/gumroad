import React from "react";
import { usePage } from "@inertiajs/react";
import AdminUserAndProductsTabs from "$app/components/Admin/UserAndProductsTabs";
import { type User as UserType } from "$app/components/Admin/Users/User";
import AdminUsersProductsProduct, { type Product as ProductType } from "$app/components/Admin/Products/Product";

type PaginationProps = {
  current_page: number;
  total_pages: number;
  total_count: number;
};

const AdminUsersProductsContent = ({ products }: { products: ProductType[] }) => {
  if (products.length > 0) {
    return (
      <div>
        {products.map((product) => (
          <AdminUsersProductsProduct key={product.id} product={product} />
        ))}
      </div>
    )
  } else {
    return (
      <div className="info" role="status">No products created.</div>
    )
  }
}

const AdminUsersProducts = () => {
  const { user, products, pagy } = usePage().props as unknown as { user: UserType; is_affiliate_user: boolean; products: ProductType[]; pagy: PaginationProps };

  console.log(user, products, pagy);
  return (
    <div className="paragraphs">
      <AdminUserAndProductsTabs selectedTab="products" user={user} />
      <AdminUsersProductsContent products={products} />
    </div>
  )
};

export default AdminUsersProducts;
