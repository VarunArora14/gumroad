
import * as React from "react";

import { Form } from "$app/components/Admin/Form";
import { showAlert } from "$app/components/server-components/Alert";

type AdminSetCustomFeeFormProps = {
  user_id: number;
  custom_fee_percent: number | null;
};

const AdminSetCustomFeeForm = ({
  user_id,
  custom_fee_percent,
}: AdminSetCustomFeeFormProps) => {
  const [customFeePercent, setCustomFeePercent] = React.useState(custom_fee_percent ?? "");
  const onCustomFeePercentChange = (evt: React.ChangeEvent<HTMLInputElement>) => {
    setCustomFeePercent(evt.target.value);
  };

  return (
    <Form
      url={Routes.set_custom_fee_admin_user_path(user_id)}
      method="POST"
      confirmMessage={`Are you sure you want to update this user's custom fee?`}
      onSuccess={() => showAlert("Custom fee updated.", "success")}
    >
      {(isLoading) => (
        <fieldset>
          <div className="input-with-button" style={{ alignItems: "start" }}>
            <input
              name="custom_fee_percent"
              type="number"
              min="0"
              max="100"
              step="0.1"
              defaultValue={customFeePercent}
              onChange={onCustomFeePercentChange}
              placeholder="Enter a custom fee percentage between 0 and 100. Submit blank to clear existing custom fee."
            />
            <button type="submit" className="button" disabled={isLoading} id="update-custom-fee">
              {isLoading ? "Submitting..." : "Submit"}
            </button>
          </div>
          <small>
            Note: Updated custom fee will apply to new direct (non-discover) sales of the user, but not to future charges
            of their existing memberships.
          </small>
        </fieldset>
      )}
    </Form>
  );
};

export default AdminSetCustomFeeForm;
