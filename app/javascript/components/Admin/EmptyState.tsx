import React from "react";

type Props = {
  message: string;
};

const EmptyState = ({ message }: Props) => {
  return (
    <div className="placeholder">
      <h2 id="empty-message">{message}</h2>
    </div>
  );
};

export default EmptyState;
