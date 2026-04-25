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
import type {
  ComprehensiveInventoryReport,
  DailyInventoryReport,
  PenInventoryOverview,
} from "@/lib/api";

function EmptyPanel({ text }: { text: string }) {
  return (
    <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
      {text}
    </div>
  );
}

function sum(values: number[]) {
  return values.reduce(
    (total, value) => total + (Number.isFinite(value) ? value : 0),
    0,
  );
}

export function PenOverviewPanel({
  data,
}: {
  data: PenInventoryOverview | null;
}) {
  if (!data) {
    return (
      <EmptyPanel text="查询栏舍看板后，这里会展示实时统计、正式统计、媒体状态和趋势。" />
    );
  }

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border bg-card p-4 shadow-xs">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <div>
            <div className="text-lg font-semibold">
              {data.penName || `栏舍 #${data.penId}`}
            </div>
            <div className="text-sm text-muted-foreground">
              {data.buildingName || `楼栋 #${data.buildingId}`} ·{" "}
              {data.orgName || `组织 #${data.orgId}`}
            </div>
          </div>
          <Badge variant="outline">{data.focusDate || "-"}</Badge>
        </div>
      </div>

      <div className="grid gap-3 md:grid-cols-3">
        <MetricCard
          label="实时建议数量"
          value={data.todayLiveStat.finalCount}
          tone="info"
        />
        <MetricCard
          label="正式确认数量"
          value={data.todayConfirmedStat.finalCount}
          tone="success"
        />
        <MetricCard
          label="死猪数"
          value={data.todayConfirmedStat.deadPigQuantity}
          tone="danger"
        />
        <MetricCard
          label="媒体总数"
          value={data.todayMediaSummary.totalMediaCount}
        />
        <MetricCard
          label="已确认媒体"
          value={data.todayMediaSummary.confirmedMediaCount}
          tone="success"
        />
        <MetricCard
          label="处理中/失败"
          value={`${data.todayMediaSummary.processingMediaCount}/${data.todayMediaSummary.failedMediaCount}`}
          tone="warning"
        />
      </div>

      <div className="rounded-2xl border bg-card">
        <div className="border-b p-3">
          <div className="font-medium">最近媒体</div>
          <div className="text-xs text-muted-foreground">
            优先关注处理失败和未确认媒体
          </div>
        </div>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>媒体ID</TableHead>
              <TableHead>类型</TableHead>
              <TableHead>数量</TableHead>
              <TableHead>处理状态</TableHead>
              <TableHead>确认</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.recentMedia.map((item) => (
              <TableRow key={item.id}>
                <TableCell>{item.id}</TableCell>
                <TableCell>{item.mediaType || "-"}</TableCell>
                <TableCell>
                  {item.manualCount > 0 ? item.manualCount : item.count}
                </TableCell>
                <TableCell>
                  <StatusBadge status={item.processingStatus || "-"} />
                </TableCell>
                <TableCell>{item.status ? "已确认" : "待确认"}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      <div className="rounded-2xl border bg-card">
        <div className="border-b p-3">
          <div className="font-medium">确认趋势</div>
          <div className="text-xs text-muted-foreground">
            {data.trendStartDate || "-"} 至 {data.trendEndDate || "-"}
          </div>
        </div>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>日期</TableHead>
              <TableHead>样本数</TableHead>
              <TableHead>平均</TableHead>
              <TableHead>最终数量</TableHead>
              <TableHead>死猪</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.confirmedTrend.map((item) => (
              <TableRow key={item.statDate}>
                <TableCell>{item.statDate}</TableCell>
                <TableCell>{item.sampleSize}</TableCell>
                <TableCell>{item.avgCount}</TableCell>
                <TableCell>{item.finalCount}</TableCell>
                <TableCell>{item.deadPigQuantity}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}

export function DailyReportPanel({
  data,
}: {
  data: DailyInventoryReport | null;
}) {
  if (!data) {
    return (
      <EmptyPanel text="查询日报后，这里会按楼栋和栏舍展示正式盘点结果。" />
    );
  }

  const pens = data.buildings.flatMap((building) =>
    building.pens.map((pen) => ({ building, pen })),
  );

  return (
    <div className="space-y-4">
      <div className="grid gap-3 md:grid-cols-4">
        <MetricCard label="楼栋数" value={data.buildings.length} />
        <MetricCard label="栏舍数" value={pens.length} />
        <MetricCard
          label="最终总数"
          value={sum(pens.map(({ pen }) => pen.finalCount))}
          tone="success"
        />
        <MetricCard
          label="死猪总数"
          value={sum(pens.map(({ pen }) => pen.deadPigQuantity))}
          tone="danger"
        />
      </div>
      <div className="rounded-2xl border bg-card">
        <div className="border-b p-3">
          <div className="font-medium">
            {data.orgName || `组织 #${data.orgId}`} 日报
          </div>
          <div className="text-xs text-muted-foreground">
            {data.reportDate || "-"}
          </div>
        </div>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>楼栋</TableHead>
              <TableHead>栏舍</TableHead>
              <TableHead>样本</TableHead>
              <TableHead>平均</TableHead>
              <TableHead>最终</TableHead>
              <TableHead>死猪</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {pens.map(({ building, pen }) => (
              <TableRow key={`${building.buildingId}-${pen.penId}`}>
                <TableCell>
                  {building.buildingName || building.buildingId}
                </TableCell>
                <TableCell>{pen.penName || pen.penId}</TableCell>
                <TableCell>{pen.sampleSize}</TableCell>
                <TableCell>{pen.avgCount}</TableCell>
                <TableCell>{pen.finalCount}</TableCell>
                <TableCell>{pen.deadPigQuantity}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}

export function ComprehensiveReportPanel({
  data,
}: {
  data: ComprehensiveInventoryReport | null;
}) {
  if (!data) {
    return (
      <EmptyPanel text="查询综合报告后，这里会展示区间内各栏舍建议数量和死猪汇总。" />
    );
  }

  const pens = data.buildings.flatMap((building) =>
    building.pens.map((pen) => ({ building, pen })),
  );

  return (
    <div className="space-y-4">
      <div className="grid gap-3 md:grid-cols-4">
        <MetricCard label="楼栋数" value={data.buildings.length} />
        <MetricCard label="栏舍数" value={pens.length} />
        <MetricCard
          label="建议总数"
          value={sum(pens.map(({ pen }) => pen.recommendedCount))}
          tone="success"
        />
        <MetricCard
          label="死猪总数"
          value={sum(pens.map(({ pen }) => pen.deadPigQuantity))}
          tone="danger"
        />
      </div>
      <div className="rounded-2xl border bg-card">
        <div className="border-b p-3">
          <div className="font-medium">
            {data.orgName || `组织 #${data.orgId}`} 综合报告
          </div>
          <div className="text-xs text-muted-foreground">
            {data.startDate || "-"} 至 {data.endDate || "-"}
          </div>
        </div>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>楼栋</TableHead>
              <TableHead>栏舍</TableHead>
              <TableHead>纳入天数</TableHead>
              <TableHead>日均</TableHead>
              <TableHead>建议数量</TableHead>
              <TableHead>死猪</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {pens.map(({ building, pen }) => (
              <TableRow key={`${building.buildingId}-${pen.penId}`}>
                <TableCell>
                  {building.buildingName || building.buildingId}
                </TableCell>
                <TableCell>{pen.penName || pen.penId}</TableCell>
                <TableCell>{pen.includedDays}</TableCell>
                <TableCell>{pen.avgDailyCount}</TableCell>
                <TableCell>{pen.recommendedCount}</TableCell>
                <TableCell>{pen.deadPigQuantity}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
