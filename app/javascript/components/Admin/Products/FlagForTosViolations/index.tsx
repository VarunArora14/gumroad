import React from "react";

import { cast } from "ts-safe-cast";
import { useLazyFetch } from "$app/hooks/useLazyFetch";

import type { User } from "$app/components/Admin/Users/User";
import type { Product } from "$app/components/Admin/Products/Product";

import AdminFlagForTosViolationsContent, { type TosViolationFlags } from "$app/components/Admin/Products/FlagForTosViolations/Content";


export type Compliance = {
  reasons: Record<string, string>;
  default_reason: string;
};

type FlagForTosViolationsProps = {
  user: User;
  product: Product;
  compliance: Compliance;
};

const FlagForTosViolations = ({ user, product, compliance }: FlagForTosViolationsProps) => {
  const [open, setOpen] = React.useState(false);
  const [flaggedForTosViolation, setFlaggedForTosViolation] = React.useState(user.flagged_for_tos_violation);

  const { data: tos_violation_flags, isLoading, fetchData: fetchTosViolationFlags } = useLazyFetch<TosViolationFlags[]>(
    [],
    {
      url: Routes.admin_user_product_tos_violation_flags_path(user.id, product.id, { format: "json" }),
      responseParser: (data) => cast<TosViolationFlags[]>(data.tos_violation_flags),
    }
  );

  const fetchIfFlagged = () => flaggedForTosViolation && fetchTosViolationFlags();

  React.useEffect(() => {
    fetchIfFlagged();
  }, [flaggedForTosViolation]);

  const onToggle = (e: React.MouseEvent<HTMLDetailsElement>) => {
    setOpen(e.currentTarget.open);
    if (e.currentTarget.open) {
      fetchIfFlagged();
    }
  };

  const markAsFlagged = () => setFlaggedForTosViolation(true);

  return (
    <>
      <hr />
      <details open={open} onToggle={onToggle}>
        <summary>
          <h3>Flag for TOS violation</h3>
        </summary>
        <AdminFlagForTosViolationsContent
          user={user}
          product={product}
          isLoading={isLoading}
          flaggedForTosViolation={flaggedForTosViolation}
          tosViolationFlags={tos_violation_flags}
          compliance={compliance}
          onSuccess={markAsFlagged}
        />
      </details>
    </>
  )
};

export default FlagForTosViolations;
