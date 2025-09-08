
import React from "react";
import { Popover } from "$app/components/Popover";
import { CurrentUser } from "$app/types/user";
import { useLoggedInUser } from "$app/components/LoggedInUser";

export type Props = {
  current_user: CurrentUser;
};

const AdminNavFooter = ({ current_user }: Props) => {
  const loggedInUser = useLoggedInUser();

  const handleUnbecome = async (ev: React.MouseEvent<HTMLAnchorElement>) => {
    ev.preventDefault();

    try {
      const response = await fetch(Routes.admin_unimpersonate_path(), {
        method: "DELETE",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content") || ""
        }
      });

      if (response.ok) {
        const data = await response.json();
        window.location.href = data.redirect_to;
      }
    } catch (error) {
      console.error("Failed to unbecome:", error);
    }
  };

  return (
    <Popover
      position="top"
      trigger={
        <>
          <img className="user-avatar" src={current_user.avatar_url} alt="Your avatar" />
          {current_user.name}
        </>
      }
    >
      <div role="menu">
        {current_user.impersonated_user ? (
          <>
            <a role="menuitem" href={Routes.root_url()}>
              <img className="user-avatar" src={current_user.impersonated_user.avatar_url} alt="Your avatar" />
              <span>{current_user.impersonated_user.name}</span>
            </a>
            <hr />
          </>
        ) : null}
        <a role="menuitem" href={Routes.logout_url()}>
          <span className="icon icon-box-arrow-in-right-fill"></span>
          Logout
        </a>
        {loggedInUser?.isImpersonating ? (
          <a role="menuitem" href="#" onClick={handleUnbecome}>
            <span className="icon icon-box-arrow-in-right-fill"></span>
            Unbecome
          </a>
        ) : null}
      </div>
    </Popover>
  );
};

export default AdminNavFooter;
