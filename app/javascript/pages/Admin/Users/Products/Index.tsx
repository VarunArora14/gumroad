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

type AdminUsersProductsContentProps = {
  products: ProductType[];
  is_affiliate_user: boolean;
}

const AdminUsersProductsContent = ({
  products,
  is_affiliate_user
}: AdminUsersProductsContentProps) => {
  if (products.length > 0) {
    return (
      <div>
        {products.map((product) => (
          <AdminUsersProductsProduct
            key={product.id}
            product={product}
            is_affiliate_user={is_affiliate_user}
          />
        ))}
      </div>
    )
  } else {
    return (
      <div className="info" role="status">No products created.</div>
    )
  }
}

type AdminUsersProductsProps = {
  user: UserType;
  products: ProductType[];
  is_affiliate_user: boolean;
  pagy: PaginationProps;
}

const AdminUsersProducts = () => {
  const {
    user,
    products,
    pagy,
    is_affiliate_user
  } = usePage().props as unknown as AdminUsersProductsProps;

  console.log(user, products, pagy);
  return (
    <div className="paragraphs">
      <AdminUserAndProductsTabs selectedTab="products" user={user} />
      <AdminUsersProductsContent products={products} is_affiliate_user={is_affiliate_user} />
    </div>
  )
};

export default AdminUsersProducts;
