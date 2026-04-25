import { Badge } from "@/components/ui/badge";

function statusVariant(status: string) {
  const upper = status.toUpperCase();
  if (upper === "SUCCESS" || upper === "DONE" || upper === "COMPLETED")
    return "default";
  if (upper === "FAILED") return "destructive";
  if (upper === "PROCESSING" || upper === "PENDING" || upper === "IN_PROGRESS")
    return "secondary";
  return "outline";
}

export function StatusBadge({ status }: { status: string }) {
  return <Badge variant={statusVariant(status)}>{status || "-"}</Badge>;
}
