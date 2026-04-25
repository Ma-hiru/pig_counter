"use client";

import { useEffect, useMemo, useState } from "react";

import { BarChart3 } from "lucide-react";

import { DateInput } from "@/components/admin/date-input";
import { subscribeAdminDataChanged } from "@/components/admin/data-events";
import { PdfExportLink } from "@/components/admin/pdf-export-link";
import {
  ComprehensiveReportPanel,
  DailyReportPanel,
  PenOverviewPanel,
} from "@/components/admin/report-panels";
import { SectionIntroCard } from "@/components/admin/section-intro-card";
import type { Notice } from "@/components/admin/types";
import { useApiRunner } from "@/components/admin/use-api-runner";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import type {
  AdminApi,
  BuildingTree,
  ComprehensiveInventoryReport,
  DailyInventoryReport,
  PdfExport,
  PenInventoryOverview,
  PenMediaSummary,
  TaskDetail,
  TaskSummary,
} from "@/lib/api";

function todayDate() {
  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, "0");
  const dd = String(now.getDate()).padStart(2, "0");
  return `${yyyy}-${mm}-${dd}`;
}

function parseNumber(raw: string) {
  const value = Number(raw);
  return Number.isFinite(value) ? value : 0;
}

export function ReportSection({
  api,
  notify,
}: {
  api: AdminApi;
  notify: (notice: Notice) => void;
}) {
  const runAction = useApiRunner(notify);

  const [buildingTree, setBuildingTree] = useState<BuildingTree | null>(null);
  const [taskList, setTaskList] = useState<TaskSummary[]>([]);
  const [reportTaskId, setReportTaskId] = useState("");
  const [reportTask, setReportTask] = useState<TaskDetail | null>(null);
  const [overviewPenId, setOverviewPenId] = useState("");
  const [overviewDate, setOverviewDate] = useState(todayDate());
  const [overviewStartDate, setOverviewStartDate] = useState(todayDate());
  const [overviewEndDate, setOverviewEndDate] = useState(todayDate());
  const [overviewData, setOverviewData] = useState<PenInventoryOverview | null>(
    null,
  );

  const [summaryList, setSummaryList] = useState<PenMediaSummary[]>([]);

  const [dailyDate, setDailyDate] = useState(todayDate());
  const [dailyReport, setDailyReport] = useState<DailyInventoryReport | null>(
    null,
  );
  const [dailyPdf, setDailyPdf] = useState<PdfExport | null>(null);

  const [compStartDate, setCompStartDate] = useState(todayDate());
  const [compEndDate, setCompEndDate] = useState(todayDate());
  const [compReport, setCompReport] =
    useState<ComprehensiveInventoryReport | null>(null);
  const [compPdf, setCompPdf] = useState<PdfExport | null>(null);

  const finalOverviewPenId = useMemo(
    () => parseNumber(overviewPenId),
    [overviewPenId],
  );

  const penOptions = useMemo(() => {
    if (reportTask) {
      return reportTask.buildings.flatMap((building) =>
        building.pens.map((pen) => ({
          id: pen.penId,
          label: pen.penName || `栏舍 #${pen.penId}`,
          buildingName: building.buildingName || `楼栋 #${building.buildingId}`,
        })),
      );
    }
    return (buildingTree?.buildings || []).flatMap((building) =>
      building.pens.map((pen) => ({
        id: pen.id,
        label: pen.name || `栏舍 #${pen.id}`,
        buildingName: building.name || `楼栋 #${building.id}`,
      })),
    );
  }, [buildingTree, reportTask]);

  function toDateOnly(value: string) {
    return value.trim().slice(0, 10);
  }

  async function loadReportDependencies() {
    await Promise.all([
      runAction(() => api.getBuildingCurrent(), {
        onData: (value) => setBuildingTree(value),
      }),
      runAction(() => api.getTaskPage(1, 50), {
        onData: (value) => setTaskList(value.list),
      }),
    ]);
  }

  async function applyTaskContext(taskIdValue: string) {
    setReportTaskId(taskIdValue);
    const taskId = parseNumber(taskIdValue);
    if (!taskId) {
      setReportTask(null);
      return;
    }
    const result = await runAction(() => api.getTaskDetail(taskId), {
      onData: (value) => {
        setReportTask(value);
        const startDate = toDateOnly(value.startTime);
        const endDate = toDateOnly(value.endTime);
        if (startDate) {
          setOverviewStartDate(startDate);
          setCompStartDate(startDate);
        }
        if (endDate) {
          setOverviewDate(endDate);
          setOverviewEndDate(endDate);
          setDailyDate(endDate);
          setCompEndDate(endDate);
        }
        const firstPen = value.buildings[0]?.pens[0]?.penId;
        if (firstPen) {
          setOverviewPenId(String(firstPen));
        }
      },
    });
    if (result === undefined) {
      setReportTaskId("");
      setReportTask(null);
    }
  }

  async function loadOverview() {
    if (!finalOverviewPenId) {
      notify({ type: "error", text: "请选择栏舍" });
      return;
    }
    await runAction(
      () =>
        api.getPenOverview({
          penId: finalOverviewPenId,
          date: overviewDate.trim(),
          startDate: overviewStartDate.trim(),
          endDate: overviewEndDate.trim(),
          recentMediaLimit: 5,
        }),
      {
        onData: (value) => setOverviewData(value),
      },
    );
  }

  async function loadMediaSummary() {
    if (
      !finalOverviewPenId ||
      !overviewStartDate.trim() ||
      !overviewEndDate.trim()
    ) {
      notify({ type: "error", text: "请选择栏舍并填写统计区间" });
      return;
    }
    await runAction(
      () =>
        api.getMediaSummary(
          finalOverviewPenId,
          overviewStartDate.trim(),
          overviewEndDate.trim(),
        ),
      {
        onData: (value) => setSummaryList(value.list),
      },
    );
  }

  async function loadDailyReport() {
    if (!dailyDate.trim()) {
      notify({ type: "error", text: "请选择日报日期" });
      return;
    }
    await runAction(() => api.getDailyReport(dailyDate.trim()), {
      onData: (value) => setDailyReport(value),
    });
  }

  async function exportDailyPdf(regenerate = false) {
    if (!dailyDate.trim()) {
      notify({ type: "error", text: "请选择日报日期" });
      return;
    }
    await runAction(() => api.getDailyReportPdf(dailyDate.trim(), regenerate), {
      onData: (value) => setDailyPdf(value),
      successText: regenerate ? "日报PDF已重生成" : "日报PDF已获取",
    });
  }

  async function loadComprehensiveReport() {
    if (!compStartDate.trim() || !compEndDate.trim()) {
      notify({ type: "error", text: "请选择综合报告起止日期" });
      return;
    }
    await runAction(
      () =>
        api.getComprehensiveReport(compStartDate.trim(), compEndDate.trim()),
      {
        onData: (value) => setCompReport(value),
      },
    );
  }

  async function exportComprehensivePdf(regenerate = false) {
    if (!compStartDate.trim() || !compEndDate.trim()) {
      notify({ type: "error", text: "请选择综合报告起止日期" });
      return;
    }
    await runAction(
      () =>
        api.getComprehensiveReportPdf(
          compStartDate.trim(),
          compEndDate.trim(),
          regenerate,
        ),
      {
        onData: (value) => setCompPdf(value),
        successText: regenerate ? "综合PDF已重生成" : "综合PDF已获取",
      },
    );
  }

  useEffect(() => {
    void loadReportDependencies();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    return subscribeAdminDataChanged(() => {
      void loadReportDependencies();
      if (reportTask?.id) {
        void applyTaskContext(String(reportTask.id));
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [reportTask?.id]);

  return (
    <div className="space-y-4">
      <SectionIntroCard
        eyebrow="统计沉淀"
        icon={BarChart3}
        title="报表中心"
        description="汇总栏舍实时看板、日报、综合报告和 PDF 导出，让盘点结果可以复盘和归档。"
        stats={[
          { label: "区间汇总", value: summaryList.length },
          { label: "栏舍看板", value: overviewData ? "已查询" : "待查询" },
          { label: "日报", value: dailyReport ? "已生成" : "待查询" },
          { label: "综合报告", value: compReport ? "已生成" : "待查询" },
        ]}
      />

      <div className="grid gap-4 xl:grid-cols-2">
        <Card className="xl:col-span-2">
          <CardHeader>
            <CardTitle>任务上下文</CardTitle>
            <CardDescription>
              先选择任务，系统会自动带入任务时间范围，并把栏舍选择限制在该任务范围内。
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-3 md:grid-cols-[minmax(0,1fr)_auto]">
            <div className="space-y-1">
              <Label>任务</Label>
              <Select value={reportTaskId} onValueChange={applyTaskContext}>
                <SelectTrigger>
                  <SelectValue placeholder="选择任务后自动带入报表上下文" />
                </SelectTrigger>
                <SelectContent>
                  {taskList.map((item) => (
                    <SelectItem key={item.id} value={String(item.id)}>
                      {item.taskName || `任务 #${item.id}`} · 员工{" "}
                      {item.employeeId}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <Button
              className="self-end"
              variant="outline"
              onClick={loadReportDependencies}
            >
              刷新任务与栏舍
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>栏舍看板与区间汇总</CardTitle>
            <CardDescription>
              查看栏舍当天看板和区间媒体统计。已选任务时，这里会优先按任务范围驱动。
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="grid gap-2 md:grid-cols-2">
              <div className="space-y-1">
                <Label>栏舍</Label>
                <Select value={overviewPenId} onValueChange={setOverviewPenId}>
                  <SelectTrigger>
                    <SelectValue placeholder="请选择栏舍" />
                  </SelectTrigger>
                  <SelectContent>
                    {penOptions.map((pen) => (
                      <SelectItem key={pen.id} value={String(pen.id)}>
                        {pen.label} · {pen.buildingName}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1">
                <Label>聚焦日期</Label>
                <DateInput value={overviewDate} onChange={setOverviewDate} />
              </div>
              <div className="space-y-1">
                <Label>统计开始日期</Label>
                <DateInput
                  value={overviewStartDate}
                  onChange={setOverviewStartDate}
                />
              </div>
              <div className="space-y-1">
                <Label>统计结束日期</Label>
                <DateInput
                  value={overviewEndDate}
                  onChange={setOverviewEndDate}
                />
              </div>
            </div>
            <div className="flex flex-wrap gap-2">
              <Button onClick={loadOverview}>查询栏舍看板</Button>
              <Button variant="outline" onClick={loadMediaSummary}>
                查询区间汇总
              </Button>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>日期</TableHead>
                  <TableHead>样本数</TableHead>
                  <TableHead>平均</TableHead>
                  <TableHead>最小</TableHead>
                  <TableHead>最大</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {summaryList.map((item) => (
                  <TableRow key={item.statDate}>
                    <TableCell>{item.statDate}</TableCell>
                    <TableCell>{item.sampleSize}</TableCell>
                    <TableCell>{item.avgCount}</TableCell>
                    <TableCell>{item.minCount}</TableCell>
                    <TableCell>{item.maxCount}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
            <PenOverviewPanel data={overviewData} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>日报与日报 PDF</CardTitle>
            <CardDescription>
              查询当天日报并导出 PDF（缓存或重生成）。
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="space-y-1">
              <Label>日报日期</Label>
              <DateInput value={dailyDate} onChange={setDailyDate} />
            </div>
            <div className="flex flex-wrap gap-2">
              <Button variant="outline" onClick={loadDailyReport}>
                查询日报
              </Button>
              <Button onClick={() => exportDailyPdf(false)}>
                导出日报PDF（缓存）
              </Button>
              <Button variant="outline" onClick={() => exportDailyPdf(true)}>
                重生成日报PDF
              </Button>
            </div>
            <PdfExportLink label="打开日报PDF" value={dailyPdf} />
            <DailyReportPanel data={dailyReport} />
          </CardContent>
        </Card>

        <Card className="xl:col-span-2">
          <CardHeader>
            <CardTitle>综合报告与综合 PDF</CardTitle>
            <CardDescription>
              查看区间综合报告，并导出综合 PDF。
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="grid gap-2 md:grid-cols-2">
              <div className="space-y-1">
                <Label>开始日期</Label>
                <DateInput value={compStartDate} onChange={setCompStartDate} />
              </div>
              <div className="space-y-1">
                <Label>结束日期</Label>
                <DateInput value={compEndDate} onChange={setCompEndDate} />
              </div>
            </div>
            <div className="flex flex-wrap gap-2">
              <Button variant="outline" onClick={loadComprehensiveReport}>
                查询综合报告
              </Button>
              <Button onClick={() => exportComprehensivePdf(false)}>
                导出综合PDF（缓存）
              </Button>
              <Button
                variant="outline"
                onClick={() => exportComprehensivePdf(true)}
              >
                重生成综合PDF
              </Button>
            </div>
            <PdfExportLink label="打开综合PDF" value={compPdf} />
            <ComprehensiveReportPanel data={compReport} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
