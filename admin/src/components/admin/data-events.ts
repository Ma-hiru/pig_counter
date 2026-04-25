"use client";

const ADMIN_DATA_CHANGED_EVENT = "pig-counter:admin-data-changed";

export function emitAdminDataChanged(reason?: string) {
  if (typeof window === "undefined") return;
  window.dispatchEvent(
    new CustomEvent(ADMIN_DATA_CHANGED_EVENT, {
      detail: { reason: reason || "unknown" },
    }),
  );
}

export function subscribeAdminDataChanged(listener: () => void) {
  if (typeof window === "undefined") {
    return () => undefined;
  }

  const wrapped = () => listener();
  window.addEventListener(ADMIN_DATA_CHANGED_EVENT, wrapped);
  return () => window.removeEventListener(ADMIN_DATA_CHANGED_EVENT, wrapped);
}
