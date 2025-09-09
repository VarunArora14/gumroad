import AdminUserGuids from "$app/components/Admin/Users/PermissionRisk/Guids";
import { createCast } from "ts-safe-cast";
import { register } from "$app/utils/serverComponentUtil";

export default register({ component: AdminUserGuids, propParser: createCast() });
