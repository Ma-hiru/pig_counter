"use client";

import { useCallback } from "react";

import {
  getApiErrorMessage,
  getApiFieldErrors,
  type ApiFieldErrors,
  type ApiResult,
} from "@/lib/api";
import type { Notice } from "@/components/admin/types";

type Notify = (notice: Notice) => void;

export function useApiRunner(notify: Notify) {
  return useCallback(
    async function runAction<T>(
      action: () => Promise<ApiResult<T>>,
      options?: {
        successText?: string;
        onData?: (value: T) => void;
        onFieldErrors?: (errors: ApiFieldErrors) => void;
      },
    ) {
      try {
        const result = await action();
        if (!result.ok) {
          const fieldErrors = getApiFieldErrors(result);
          if (fieldErrors && options?.onFieldErrors) {
            options.onFieldErrors(fieldErrors);
          } else {
            notify({ type: "error", text: getApiErrorMessage(result) });
          }
          return undefined;
        }
        options?.onData?.(result.data as T);
        if (options?.successText) {
          notify({ type: "success", text: options.successText });
        }
        return result.data as T;
      } catch (error) {
        notify({
          type: "error",
          text: error instanceof Error ? error.message : "请求失败，请稍后重试",
        });
        return undefined;
      }
    },
    [notify],
  );
}
