import type { PdfExport } from "@/lib/api";

export function PdfExportLink({
  label,
  value,
}: {
  label: string;
  value: PdfExport | null;
}) {
  if (!value?.accessUrl) return null;

  return (
    <a
      className="inline-flex text-sm text-primary underline-offset-4 hover:underline"
      href={value.accessUrl}
      target="_blank"
      rel="noreferrer"
    >
      {label}：{value.fileName || value.objectKey}
    </a>
  );
}
