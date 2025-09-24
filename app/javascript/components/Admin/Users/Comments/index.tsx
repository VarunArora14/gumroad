import React from "react";
import { cast } from "ts-safe-cast";
import type { User } from "$app/components/Admin/Users/User";

import { useLazyPaginatedFetch } from "$app/hooks/useLazyFetch";

import AdminUserCommentsContent from "$app/components/Admin/Users/Comments/Content";
import AdminUserCommentsForm from "$app/components/Admin/Users/Comments/Form";
import type { CommentProps } from "$app/components/Admin/Users/Comments/Comment";

type AdminUserCommentsProps = {
  user: User;
};

const AdminUserComments = ({
  user
}: AdminUserCommentsProps) => {
  const [open, setOpen] = React.useState(false);

  const { data: comments, isLoading, setData: setComments, fetchData: fetchComments, hasMore, pagination } = useLazyPaginatedFetch<CommentProps[]>(
    [] as CommentProps[],
    {
      url: Routes.admin_user_comments_path(user.id, { format: "json" }),
      responseParser: (data) => cast<CommentProps[]>(data.comments),
      mode: "append",
    }
  );

  const onToggle = (e: React.MouseEvent<HTMLDetailsElement>) => {
    setOpen(e.currentTarget.open);
    if (e.currentTarget.open) {
      fetchComments();
    } else {
      setComments([]);
    }
  }

  const onCommentAdded = (comment: CommentProps) => {
    setComments([comment, ...comments]);
  }

  const fetchNextPage = () => {
    if (pagination?.next) {
      fetchComments({ page: pagination.next });
    }
  }

  return (
    <>
      <hr />
      <details open={open} onToggle={onToggle} className="space-y-2">
        <summary>
          <h3>Comments</h3>
        </summary>
        <AdminUserCommentsForm commentable_id={user.id} onCommentAdded={onCommentAdded} />
        <AdminUserCommentsContent
          count={pagination.count}
          comments={comments}
          isLoading={isLoading}
          hasMore={hasMore}
          onLoadMore={fetchNextPage}
        />
      </details>
    </>
  )
};

export default AdminUserComments;
