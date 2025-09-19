import React from "react";
import { classNames } from "$app/utils/classNames";

type TabProps = {
  children: React.ReactNode;
  isSelected?: boolean;
  onClick?: () => void;
  ariaControls?: string;
  className?: string;
  nodeName?: string;
}

const Tab = ({
  children,
  isSelected,
  onClick = () => {},
  ariaControls,
  className,
  nodeName = "div" as keyof JSX.IntrinsicElements,
}: TabProps) => {
  const Node = nodeName as keyof JSX.IntrinsicElements;

  return (
    <Node
      role="tab"
      className={classNames(
        "opacity-70",
        "dark:text-white/70 dark:font-bold",
        "border border-border rounded",
        "hover:-translate-x-1 hover:-translate-y-1 hover:shadow-[0.25rem_0.25rem_0_currentColor]",
        "transition-[opacity,transform] ease-out duration-200",
        {
          "opacity-100 font-bold bg-white dark:bg-transparent dark:text-white": isSelected
        },
        className
      )}
      aria-selected={isSelected}
      aria-controls={ariaControls}
      onClick={onClick}
    >
      {children}
    </Node>
  );
};

export default Tab;
