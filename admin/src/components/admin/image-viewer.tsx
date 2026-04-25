"use client";

import { useState } from "react";
import Image from "next/image";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { cn } from "@/lib/utils";

export function ImageViewer({
  src,
  alt,
  className,
  thumbClassName,
  containerClassName,
  dialogTitle = "图片预览",
  dialogDescription = "点击图片可查看大图细节。",
  width = 960,
  height = 640,
}: {
  src?: string | null;
  alt: string;
  className?: string;
  thumbClassName?: string;
  containerClassName?: string;
  dialogTitle?: string;
  dialogDescription?: string;
  width?: number;
  height?: number;
}) {
  const [open, setOpen] = useState(false);

  if (!src) return null;

  return (
    <>
      <button
        type="button"
        className={cn("block w-full text-left", containerClassName)}
        onClick={() => setOpen(true)}
      >
        <Image
          src={src}
          alt={alt}
          width={width}
          height={height}
          unoptimized
          className={cn(
            "cursor-zoom-in rounded-xl object-cover transition hover:opacity-95",
            className,
            thumbClassName,
          )}
        />
      </button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="max-w-6xl">
          <DialogHeader>
            <DialogTitle>{dialogTitle}</DialogTitle>
            <DialogDescription>{dialogDescription}</DialogDescription>
          </DialogHeader>
          <div className="flex max-h-[78vh] items-center justify-center overflow-auto rounded-xl border border-border/60 bg-muted/10 p-3">
            <Image
              src={src}
              alt={alt}
              width={1600}
              height={1200}
              unoptimized
              className="h-auto max-h-[72vh] w-auto max-w-full rounded-lg object-contain"
            />
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
