import React from "react";
import { formatDate } from "$app/utils/date";
import { WithTooltip } from "$app/components/WithTooltip";
import { formatDistanceToNow } from 'date-fns';

import Loading from "$app/components/Admin/Loading";

export type EmailChangesProps = {
  created_at: string;
  changes: {
    email?: string[];
    payment_address?: string[];
  };
}[];

export type FieldsProps = ['email', 'payment_address'];


type EmailChangesComponentProps = {
  fields: FieldsProps;
  emailChanges: EmailChangesProps;
  isLoading: boolean;
};

const EmailChanges = ({ fields, emailChanges, isLoading }: EmailChangesComponentProps) => {
  if (isLoading) return <Loading />;

  if (!emailChanges) return <div>No email changes found.</div>;

  return (
    <table>
      <thead>
        <tr>
          <th>Field</th>
          <th>Old</th>
          <th>New</th>
          <th>Changed</th>
        </tr>
      </thead>
      <tbody>
        {fields.map((field) => (
          <React.Fragment key={field}>
            {Object.values(emailChanges).map(({ created_at, changes }) => {
              const fieldChanges = changes[field] as string[] | undefined;
              if (!fieldChanges) return null;

              const [oldValue, newValue] = fieldChanges;

              return (
                <tr key={created_at}>
                  <td data-label="Field">{field}</td>
                  <td data-label="Old">{oldValue}</td>
                  <td data-label="New">{newValue}</td>
                  <td data-label="Changed">
                    <WithTooltip tip={formatDistanceToNow(new Date(created_at), { addSuffix: true })}>
                      {formatDate(new Date(created_at))}
                    </WithTooltip>
                  </td>
                </tr>
              );
            })}
          </React.Fragment>
        ))}
      </tbody>
    </table>
  );
};

export default EmailChanges;
