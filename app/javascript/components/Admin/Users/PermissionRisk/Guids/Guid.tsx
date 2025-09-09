import React from "react";

type GuidProps = {
  guid: string;
  user_ids: number[];
};

const Guid = ({ guid, user_ids }: GuidProps) => (
  <div>
    <h5>
      <a href={Routes.admin_guid_path(guid)}>{guid}</a>
    </h5>
    <span>{user_ids.length} users</span>
  </div>
);

export default Guid;
