import React from "react";
import { cast } from "ts-safe-cast";
import type { User } from "$app/components/Admin/Users/User";

import { useLazyFetch } from "$app/hooks/useLazyFetch";

import Comments from "$app/components/Admin/Users/Comments/Comments";
import Form from "$app/components/Admin/Users/Comments/Form";
import type { CommentProps } from "$app/components/Admin/Users/Comments/Comment";

type AdminUserCommentsProps = {
  user: User;
};

const AdminUserComments = ({
  user
}: AdminUserCommentsProps) => {
  const [open, setOpen] = React.useState(false);

  const { data: comments, isLoading, setData: setComments, fetchData: fetchComments } = useLazyFetch<CommentProps[]>(
    [] as CommentProps[],
    {
      url: Routes.admin_user_comments_path(user.id, { format: "json" }),
      responseParser: (data) => cast<CommentProps[]>(data.comments),
    }
  );

  const onToggle = (e: React.MouseEvent<HTMLDetailsElement>) => {
    setOpen(e.currentTarget.open);
    if (e.currentTarget.open) {
      fetchComments();
    }
  }

  const onCommentAdded = (comment: CommentProps) => {
    setComments([comment, ...comments]);
  }

  return (
    <>
      <hr />
      <details open={open} onToggle={onToggle} className="space-y-2">
        <summary>
          <h3>Comments</h3>
        </summary>
        <Form commentable_id={user.id} onCommentAdded={onCommentAdded} />
        <Comments comments={comments} isLoading={isLoading} />
      </details>
    </>
  )
};

export default AdminUserComments;
