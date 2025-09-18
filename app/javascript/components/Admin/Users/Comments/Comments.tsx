import React from "react";

import Comment, { type CommentProps } from "$app/components/Admin/Users/Comments/Comment";

type AdminUserCommentsCommentsProps = {
  comments: CommentProps[];
  isLoading: boolean;
};

const AdminUserCommentsComments = ({
  comments,
  isLoading,
}: AdminUserCommentsCommentsProps) => {
  if (isLoading) return <div role="progressbar" className="inline-block !w-3" />

  if (comments.length === 0) return <div className="info" role="status">No comments created.</div>

  return (
    <div>
      <h4 className="font-bold mb-2">{comments.length === 1 ? '1 comment' : `${comments.length} comments`}</h4>
      <div className="rows" role="list">
        {comments.map((comment) => (
          <Comment key={comment.id} comment={comment} />
        ))}
      </div>
    </div>
  )
};

export default AdminUserCommentsComments;
