import * as React from "react";
import { createCast } from "ts-safe-cast";

import { register } from "$app/utils/serverComponentUtil";

import { Form } from "$app/components/Admin/Form";
import { showAlert } from "$app/components/server-components/Alert";

export const AdminAddCommentForm = ({
  commentable_id,
  commentable_type,
  title = "Activity log",
}: {
  commentable_id: number;
  commentable_type: string;
  title?: string;
}) => (
  <Form
    url={Routes.admin_comments_path()}
    method="POST"
    confirmMessage={`Add entry to ${title}?`}
    onSuccess={() => showAlert("Entry added to activity log.", "success")}
  >
    {(isLoading) => (
      <fieldset>
        <div className="input-with-button">
          <textarea name="comment[content]" rows={1} placeholder={`Add activity for this ${commentable_type}`} required />
          <input type="hidden" name="comment[commentable_id]" value={commentable_id} />
          <input type="hidden" name="comment[commentable_type]" value={commentable_type} />
          <button type="submit" className="button" disabled={isLoading}>
            {isLoading ? "Saving..." : "Add entry"}
          </button>
        </div>
      </fieldset>
    )}
  </Form>
);

export default register({ component: AdminAddCommentForm, propParser: createCast() });
