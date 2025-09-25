import * as React from "react";

import { classNames } from "$app/utils/classNames";

export const Card = React.forwardRef<HTMLDivElement, React.HTMLProps<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={classNames("grid gap-4 rounded border border-border bg-background p-4")} {...props} />
  ),
);
Card.displayName = "Card";
