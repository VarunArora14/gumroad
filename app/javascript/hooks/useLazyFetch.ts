import React from "react";
import { assertResponseError, request } from "$app/utils/request";
import { showAlert } from "$app/components/server-components/Alert";

export interface UseLazyFetchOptions<T> {
  url: string;
  responseParser: (data: any) => T;
}

export interface UseLazyFetchResult<T> {
  data: T;
  isLoading: boolean;
  fetchData: () => Promise<void>;
}

export const useLazyFetch = <T>(
  initialData: T,
  options: UseLazyFetchOptions<T>
): UseLazyFetchResult<T> => {
  const [data, setData] = React.useState<T>(initialData);
  const [isLoading, setIsLoading] = React.useState(true);
  const [hasLoaded, setHasLoaded] = React.useState(false);

  const fetchData = React.useCallback(async () => {
    if (hasLoaded) return;

    setIsLoading(true);
    try {
      const response = await request({
        method: "GET",
        accept: "json",
        url: options.url,
      });
      const responseData = await response.json();
      const parsedData = options.responseParser(responseData);
      setData(parsedData);
      setHasLoaded(true);
    } catch (e) {
      assertResponseError(e);
      showAlert(e.message, "error");
    } finally {
      setIsLoading(false);
    }
  }, [options.url, options.responseParser, hasLoaded]);

  return {
    data,
    isLoading,
    fetchData,
  };
};
