import React from "react";
import { Link } from "@inertiajs/react";
import { formatDistanceToNow } from 'date-fns';
import { formatDate } from "$app/utils/date";
import { WithTooltip } from "$app/components/WithTooltip";

type AuthorProps = {
  id: number;
  email: string;
  name: string | null;
};

export type CommentProps = {
  id: number;
  author_name: string | null;
  comment_type: string;
  updated_at: string;
  content_formatted: string;
  author: AuthorProps | null;
};

const AdminCommentableComment = ({ comment }: { comment: CommentProps }) => (
  <div role="listitem">
    <div className="content">
      <div>
        <ul className="inline mb-2">
          <li><strong>{comment.comment_type}</strong></li>
          <li>
            {
              comment.author ?
                <Link href={Routes.admin_user_url(comment.author.id)}>{comment.author.name || comment.author.email}</Link> :
                comment.author_name
            }
          </li>
          <li>
            <WithTooltip tip={formatDistanceToNow(new Date(comment.updated_at), { addSuffix: true })}>
              {formatDate(new Date(comment.updated_at))}
            </WithTooltip>
          </li>
        </ul>
        <div dangerouslySetInnerHTML={{ __html: comment.content_formatted }} />
      </div>
    </div>
  </div>
);

export default AdminCommentableComment;
