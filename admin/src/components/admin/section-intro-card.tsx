import type { ComponentType } from "react";

import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

type IntroStat = {
  label: string;
  value: string | number;
};

export function SectionIntroCard({
  title,
  description,
  eyebrow,
  icon: Icon,
  stats,
}: {
  title: string;
  description: string;
  eyebrow: string;
  icon: ComponentType<{ className?: string }>;
  stats: IntroStat[];
}) {
  return (
    <Card className="border-primary/10 bg-card/95 shadow-xs">
      <CardHeader className="gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex items-start gap-3">
          <div className="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary text-primary-foreground">
            <Icon className="size-5" />
          </div>
          <div className="space-y-1">
            <Badge variant="secondary" className="rounded-lg">
              {eyebrow}
            </Badge>
            <CardTitle className="text-xl font-semibold tracking-tight">
              {title}
            </CardTitle>
            <CardDescription className="max-w-2xl">
              {description}
            </CardDescription>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <Separator className="mb-3" />
        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
          {stats.map((item, index) => (
            <Card
              key={`${item.label}-${index}`}
              size="sm"
              className={cn(
                "gap-0 bg-muted/35 py-0 shadow-none",
                index === 0 && "border-primary/20 bg-primary/5",
              )}
            >
              <CardContent className="p-3">
                <div className="text-xs text-muted-foreground">
                  {item.label}
                </div>
                <div className="mt-1 text-xl font-semibold tracking-tight">
                  {item.value}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
