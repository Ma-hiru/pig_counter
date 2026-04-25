"use client";

import type { ReactNode } from "react";

import { ImageViewer } from "@/components/admin/image-viewer";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { StatusBadge } from "@/components/admin/status-badge";
import type {
  DeadPigReport,
  EmployeeRecord,
  MediaRecord,
  PenRecord,
} from "@/lib/api";
import { resolveAssetUrl } from "@/lib/api";
import { cn } from "@/lib/utils";

function textOrDash(value?: string | number | null) {
  if (value === null || value === undefined || value === "") {
    return "-";
  }
  return String(value);
}

function DetailItem({
  label,
  value,
  className,
}: {
  label: string;
  value: ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "rounded-xl border border-border/70 bg-muted/20 p-3",
        className,
      )}
    >
      <div className="text-xs text-muted-foreground">{label}</div>
      <div className="mt-1 text-sm font-medium text-foreground">{value}</div>
    </div>
  );
}

export function EmployeeDetailCard({
  employee,
  organizationName,
}: {
  employee: EmployeeRecord | null;
  organizationName?: string;
}) {
  if (!employee) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        暂无员工详情。
      </div>
    );
  }

  const displayName =
    employee.name || employee.username || `员工 #${employee.id}`;
  const userInitial = displayName.slice(0, 1).toUpperCase();

  return (
    <div className="space-y-4">
      <Card className="border-border/70 shadow-none">
        <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
          <Avatar className="size-16 border border-border/60">
            <AvatarImage
              src={resolveAssetUrl(employee.profilePicture)}
              alt={displayName}
            />
            <AvatarFallback>{userInitial}</AvatarFallback>
          </Avatar>
          <div className="min-w-0 flex-1 space-y-2">
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="text-lg font-semibold">{displayName}</h3>
              <Badge variant={employee.admin ? "default" : "outline"}>
                {employee.admin ? "管理员" : "员工"}
              </Badge>
              <Badge variant="secondary">#{employee.id}</Badge>
            </div>
            <p className="text-sm text-muted-foreground">
              {employee.username || "-"} ·{" "}
              {organizationName ||
                employee.organization ||
                `组织 ${employee.orgId}`}
            </p>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-3 md:grid-cols-2">
        <DetailItem label="账号" value={textOrDash(employee.username)} />
        <DetailItem label="姓名" value={textOrDash(employee.name)} />
        <DetailItem label="性别" value={textOrDash(employee.sex)} />
        <DetailItem label="手机号" value={textOrDash(employee.phone)} />
        <DetailItem
          label="组织"
          value={textOrDash(
            organizationName || employee.organization || employee.orgId,
          )}
        />
        <DetailItem label="组织ID" value={employee.orgId} />
      </div>
      {resolveAssetUrl(employee.profilePicture) ? (
        <Card className="border-border/70 shadow-none">
          <CardHeader>
            <CardTitle>头像预览</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="overflow-hidden rounded-2xl border border-border/60 bg-muted/10 p-3">
              <ImageViewer
                src={resolveAssetUrl(employee.profilePicture)}
                alt={displayName}
                className="h-48 w-full rounded-xl object-cover"
                containerClassName="overflow-hidden rounded-xl"
              />
            </div>
          </CardContent>
        </Card>
      ) : null}
    </div>
  );
}

export function PenDetailCard({
  pen,
  buildingName,
}: {
  pen: PenRecord | null;
  buildingName?: string;
}) {
  if (!pen) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        暂无栏舍详情。
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <Card className="border-border/70 shadow-none">
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            <span>{pen.penName || `栏舍 #${pen.id}`}</span>
            <Badge variant="secondary">#{pen.id}</Badge>
          </CardTitle>
        </CardHeader>
        <CardContent className="grid gap-3 md:grid-cols-2">
          <DetailItem label="栏舍编码" value={textOrDash(pen.penCode)} />
          <DetailItem label="栏舍名称" value={textOrDash(pen.penName)} />
          <DetailItem label="所属楼栋ID" value={pen.buildingId} />
          <DetailItem label="所属楼栋" value={textOrDash(buildingName)} />
        </CardContent>
      </Card>
    </div>
  );
}

export function MediaDetailCard({ media }: { media: MediaRecord | null }) {
  if (!media) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        暂无媒体详情。
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <Card className="border-border/70 shadow-none">
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            <span>媒体 #{media.id}</span>
            <StatusBadge status={media.processingStatus || "-"} />
            <Badge variant={media.status ? "default" : "outline"}>
              {media.status ? "已确认" : "待确认"}
            </Badge>
            <Badge variant={media.duplicate ? "destructive" : "secondary"}>
              {media.duplicate ? "疑似重复" : "正常"}
            </Badge>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
            <DetailItem label="任务ID" value={media.taskId} />
            <DetailItem label="栏舍ID" value={media.penId} />
            <DetailItem label="媒体类型" value={textOrDash(media.mediaType)} />
            <DetailItem label="组织ID" value={media.orgId} />
            <DetailItem label="AI数量" value={media.count} />
            <DetailItem label="人工数量" value={media.manualCount} />
            <DetailItem
              label="拍摄时间"
              value={textOrDash(media.captureTime)}
            />
            <DetailItem label="日期桶" value={textOrDash(media.dayBucket)} />
          </div>
          <div className="grid gap-3 md:grid-cols-2">
            {resolveAssetUrl(
              media.thumbnailPath ||
                media.outputPicturePath ||
                media.picturePath,
            ) ? (
              <DetailItem
                label="媒体预览"
                className="md:col-span-2"
                value={
                  <ImageViewer
                    src={resolveAssetUrl(
                      media.thumbnailPath ||
                        media.outputPicturePath ||
                        media.picturePath,
                    )}
                    alt={`媒体 ${media.id}`}
                    className="max-h-64 w-full rounded-xl object-cover"
                    containerClassName="overflow-hidden rounded-xl"
                  />
                }
              />
            ) : null}
            <DetailItem
              label="原始图片路径"
              value={
                <span className="break-all text-xs font-normal">
                  {textOrDash(media.picturePath)}
                </span>
              }
            />
            <DetailItem
              label="输出图片路径"
              value={
                <span className="break-all text-xs font-normal">
                  {textOrDash(media.outputPicturePath)}
                </span>
              }
            />
            <DetailItem
              label="缩略图路径"
              value={
                <span className="break-all text-xs font-normal">
                  {textOrDash(media.thumbnailPath)}
                </span>
              }
            />
            <DetailItem
              label="处理说明"
              value={
                <span className="break-all text-xs font-normal">
                  {textOrDash(media.processingMessage)}
                </span>
              }
            />
          </div>
          <div className="rounded-xl border border-dashed bg-muted/10 p-3 text-xs leading-5 text-muted-foreground">
            {media.analysisJson
              ? "AI 原始分析结果已返回，管理端不再直接展示 JSON 原文，避免界面阅读负担。"
              : "当前媒体没有额外的 AI 原始分析输出。"}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

export function DeadPigDetailCard({
  report,
}: {
  report: DeadPigReport | null;
}) {
  if (!report) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        暂无死猪日报详情。
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <Card className="border-border/70 shadow-none">
        <CardHeader>
          <CardTitle className="flex flex-wrap items-center gap-2">
            <span>死猪日报 #{report.reportId}</span>
            <Badge variant="secondary">栏舍 {report.penId}</Badge>
            <Badge variant="outline">{textOrDash(report.status)}</Badge>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
            <DetailItem
              label="上报日期"
              value={textOrDash(report.reportDate)}
            />
            <DetailItem label="数量" value={report.quantity} />
            <DetailItem label="创建时间" value={textOrDash(report.createdAt)} />
            <DetailItem label="组织ID" value={report.orgId} />
          </div>
          <DetailItem
            label="备注"
            value={
              <span className="whitespace-pre-wrap text-sm font-normal">
                {textOrDash(report.remark)}
              </span>
            }
          />
          <div className="space-y-2">
            <div className="text-sm font-medium">关联媒体</div>
            {report.mediaList.length ? (
              <div className="grid gap-3 md:grid-cols-2">
                {report.mediaList.map((media) => (
                  <DetailItem
                    key={media.id}
                    label={`媒体 #${media.id}`}
                    value={
                      <div className="space-y-3 text-xs font-normal text-muted-foreground">
                        {resolveAssetUrl(media.picturePath) ? (
                          <ImageViewer
                            src={resolveAssetUrl(media.picturePath)}
                            alt={`死猪日报媒体 ${media.id}`}
                            className="h-40 w-full rounded-xl object-cover"
                            containerClassName="overflow-hidden rounded-xl"
                          />
                        ) : null}
                        <div>相似度：{textOrDash(media.similarityScore)}</div>
                        <div className="break-all">
                          {textOrDash(media.picturePath)}
                        </div>
                      </div>
                    }
                  />
                ))}
              </div>
            ) : (
              <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
                当前日报未关联媒体。
              </div>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
