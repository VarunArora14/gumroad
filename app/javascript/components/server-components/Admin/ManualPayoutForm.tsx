import { createCast } from "ts-safe-cast";
import AdminManualPayoutForm from "$app/components/Admin/Users/PayoutInfo/ManualPayoutForm";
import { register } from "$app/utils/serverComponentUtil";
export default register({ component: AdminManualPayoutForm, propParser: createCast() });
