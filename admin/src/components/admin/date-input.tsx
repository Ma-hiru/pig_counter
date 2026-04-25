"use client";

import { Input } from "@/components/ui/input";

export function DateInput({
  value,
  onChange,
  min,
  max,
}: {
  value: string;
  onChange: (value: string) => void;
  min?: string;
  max?: string;
}) {
  return (
    <Input
      type="date"
      value={value}
      min={min}
      max={max}
      onChange={(event) => onChange(event.target.value)}
    />
  );
}

export function DateTimeInput({
  value,
  onChange,
}: {
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <Input
      type="datetime-local"
      value={value}
      onChange={(event) => onChange(event.target.value)}
    />
  );
}
