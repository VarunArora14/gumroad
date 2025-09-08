// Backward compatibility until we remove server components
import AdminActionButton from "$app/components/Admin/ActionButton";
import { createCast } from "ts-safe-cast";
import { register } from "$app/utils/serverComponentUtil";

export default register({ component: AdminActionButton, propParser: createCast() });
