import React from "react";

const TabList = ({ children }: { children: React.ReactNode }) => {
  return (
    <div role="tablist" className="grid grid-flow-col auto-cols-[1fr] gap-3">
      {children}
    </div>
  );
};

export default TabList;
