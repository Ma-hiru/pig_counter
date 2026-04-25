"use client";

import { ScrollArea } from "@/components/ui/scroll-area";

export function JsonPreview({ value, maxHeight = 260 }: { value: unknown; maxHeight?: number }) {
  return (
    <ScrollArea
      className="rounded-lg border border-border/80 bg-muted/45 p-3"
      style={{ maxHeight }}
    >
      <pre className="text-xs leading-5 text-foreground">{JSON.stringify(value, null, 2)}</pre>
    </ScrollArea>
  );
}
