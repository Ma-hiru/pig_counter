"use client";

import { CircleCheck, CircleX, Info, X } from "lucide-react";

import type { Notice } from "@/components/admin/types";
import { cn } from "@/lib/utils";

function noticeClass(type: Notice["type"]) {
  if (type === "success") {
    return "border-emerald-200 bg-emerald-50 text-emerald-700";
  }
  if (type === "error") {
    return "border-red-200 bg-red-50 text-red-700";
  }
  return "border-sky-200 bg-sky-50 text-sky-700";
}

export function NoticeBanner({
  notice,
  className,
  onDismiss,
}: {
  notice: Notice | null;
  className?: string;
  onDismiss?: () => void;
}) {
  if (!notice) return null;

  const Icon =
    notice.type === "success"
      ? CircleCheck
      : notice.type === "error"
        ? CircleX
        : Info;

  return (
    <div
      className={cn(
        "flex items-start gap-2 rounded-lg border px-3 py-2 text-sm leading-5",
        noticeClass(notice.type),
        className,
      )}
    >
      <Icon className="mt-0.5 size-4 shrink-0" />
      <span className="min-w-0 flex-1">{notice.text}</span>
      {onDismiss ? (
        <button
          type="button"
          className="rounded-md p-1 text-current/70 transition hover:bg-black/5 hover:text-current"
          onClick={onDismiss}
          aria-label="关闭提示"
        >
          <X className="size-4" />
        </button>
      ) : null}
    </div>
  );
}
