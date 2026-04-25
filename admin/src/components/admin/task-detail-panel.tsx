import { MetricCard } from "@/components/admin/metric-card";
import { StatusBadge } from "@/components/admin/status-badge";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import type { TaskDetail } from "@/lib/api";

function statusText(status: string) {
  switch (status) {
    case "PENDING":
      return "待接收";
    case "IN_PROGRESS":
      return "进行中";
    case "COMPLETED":
      return "已完成";
    default:
      return status || "-";
  }
}

function percent(value: number, total: number) {
  if (!total) return 0;
  return Math.round((value / total) * 100);
}

export function TaskDetailPanel({ task }: { task: TaskDetail | null }) {
  if (!task) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        选择任务或输入任务 ID 后，这里会展示执行进度、楼栋栏舍明细和媒体状态。
      </div>
    );
  }

  const progress = percent(task.confirmedPenCount, task.assignedPenCount);
  const pendingReviewCount = Math.max(
    task.uploadedPenCount - task.confirmedPenCount,
    0,
  );
  const allPens = task.buildings.flatMap((building) =>
    building.pens.map((pen) => ({ building, pen })),
  );

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border bg-card p-4 shadow-xs">
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="text-lg font-semibold">
                {task.taskName || `任务 #${task.id}`}
              </h3>
              <StatusBadge status={task.taskStatus} />
            </div>
            <p className="mt-1 text-sm text-muted-foreground">
              员工 ID：{task.employeeId} · 任务 ID：{task.id} · 组织 ID：
              {task.orgId}
            </p>
          </div>
          <Badge variant="outline">确认进度 {progress}%</Badge>
        </div>
        <div className="mt-3 h-2 overflow-hidden rounded-full bg-muted">
          <div
            className="h-full rounded-full bg-primary transition-all"
            style={{ width: `${Math.min(progress, 100)}%` }}
          />
        </div>
        <div className="mt-3 grid gap-2 text-xs text-muted-foreground md:grid-cols-3">
          <div>开始：{task.startTime || "-"}</div>
          <div>结束：{task.endTime || "-"}</div>
          <div>完成：{task.completedAt || "-"}</div>
        </div>
      </div>

      <div className="grid gap-3 md:grid-cols-3 xl:grid-cols-6">
        <MetricCard
          label="分配栏舍"
          value={task.assignedPenCount}
          hint="任务范围"
        />
        <MetricCard label="已上传" value={task.uploadedPenCount} tone="info" />
        <MetricCard
          label="已确认"
          value={task.confirmedPenCount}
          tone="success"
        />
        <MetricCard
          label="处理中"
          value={task.processingPenCount}
          tone="warning"
        />
        <MetricCard label="失败" value={task.failedPenCount} tone="danger" />
        <MetricCard label="待复核" value={pendingReviewCount} tone="warning" />
      </div>

      <div className="rounded-2xl border bg-card">
        <div className="border-b p-3">
          <div className="font-medium">栏舍执行明细</div>
          <div className="text-xs text-muted-foreground">
            共 {task.buildings.length} 栋、{allPens.length} 个栏舍
          </div>
        </div>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>楼栋</TableHead>
              <TableHead>栏舍</TableHead>
              <TableHead>媒体类型</TableHead>
              <TableHead>数量</TableHead>
              <TableHead>处理状态</TableHead>
              <TableHead>复核</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {allPens.map(({ building, pen }) => (
              <TableRow key={`${building.buildingId}-${pen.penId}`}>
                <TableCell>
                  {building.buildingName || building.buildingId}
                </TableCell>
                <TableCell>{pen.penName || pen.penId}</TableCell>
                <TableCell>{pen.mediaType || "-"}</TableCell>
                <TableCell>
                  {pen.manualCount > 0 ? pen.manualCount : pen.count}
                </TableCell>
                <TableCell>
                  <StatusBadge
                    status={
                      pen.processingStatus ||
                      (pen.picturePath ? "待复核" : "未上传")
                    }
                  />
                </TableCell>
                <TableCell>{pen.status ? "已确认" : "待确认"}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}

export { statusText as taskStatusText };
