import React from "react";

import { Nav } from "$app/components/Nav";
import { CurrentSellerProvider, parseCurrentSeller } from "$app/components/CurrentSeller";
import { DesignContextProvider, DesignSettings } from "$app/components/DesignSettings";
import { DomainSettingsProvider } from "$app/components/DomainSettings";
import LoadingSkeleton from "$app/components/LoadingSkeleton";
import { LoggedInUserProvider, parseLoggedInUser } from "$app/components/LoggedInUser";
import { SSRLocationProvider } from "$app/components/useOriginalLocation";
import { UserAgentProvider } from "$app/components/UserAgent";
import useRouteLoading from "$app/components/useRouteLoading";

import { LoggedInUser, Seller } from "$app/types/user";
import { DomainSettings } from "$app/types/domain_settings";

type GlobalProps = {
  design_settings: DesignSettings;
  domain_settings: DomainSettings;
  user_agent_info: {
    is_mobile: boolean;
  };
  logged_in_user: LoggedInUser;
  current_seller: Seller;
  href: string;
  locale: string;
};

export default function AppWrapper({ children, global }: { children: React.ReactNode; global: GlobalProps }) {
  const isRouteLoading = useRouteLoading();

  return (
    <DesignContextProvider value={global.design_settings}>
      <DomainSettingsProvider
        value={{
          scheme: global.domain_settings.scheme,
          appDomain: global.domain_settings.app_domain,
          rootDomain: global.domain_settings.root_domain,
          shortDomain: global.domain_settings.short_domain,
          discoverDomain: global.domain_settings.discover_domain,
          thirdPartyAnalyticsDomain: global.domain_settings.third_party_analytics_domain,
        }}
      >
        <UserAgentProvider
          value={{
            isMobile: global.user_agent_info.is_mobile,
            locale: global.locale,
          }}
        >
          <LoggedInUserProvider value={parseLoggedInUser(global.logged_in_user)}>
            <CurrentSellerProvider value={parseCurrentSeller(global.current_seller)}>
              <SSRLocationProvider value={global.href}>
                <div id="inertia-shell" className="override grid h-[100vh] grid-cols-1 grid-rows-1">
                  <Nav title="Dashboard" />
                  {isRouteLoading ? <LoadingSkeleton /> : null}
                  <div className={isRouteLoading ? "hidden" : "overflow-y-scroll"}>{children}</div>
                </div>
              </SSRLocationProvider>
            </CurrentSellerProvider>
          </LoggedInUserProvider>
        </UserAgentProvider>
      </DomainSettingsProvider>
    </DesignContextProvider>
  );
}
