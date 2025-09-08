import AdminFlagForFraudForm from "$app/components/Admin/Users/PermissionRisk/FlagForFraud/Form";
import { createCast } from "ts-safe-cast";
import { register } from "$app/utils/serverComponentUtil";

export default register({ component: AdminFlagForFraudForm, propParser: createCast() });
