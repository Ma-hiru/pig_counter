"use client";

import { useEffect, useMemo, useState } from "react";

import { ShieldCheck } from "lucide-react";

import {
  emitAdminDataChanged,
  subscribeAdminDataChanged,
} from "@/components/admin/data-events";
import { DateInput } from "@/components/admin/date-input";
import {
  DeadPigDetailCard,
  MediaDetailCard,
} from "@/components/admin/entity-detail-cards";
import { ImageViewer } from "@/components/admin/image-viewer";
import { SectionIntroCard } from "@/components/admin/section-intro-card";
import { StatusBadge } from "@/components/admin/status-badge";
import { taskStatusText } from "@/components/admin/task-detail-panel";
import type { Notice } from "@/components/admin/types";
import { useApiRunner } from "@/components/admin/use-api-runner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
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
  DeadPigReport,
  MediaRecord,
  TaskDetail,
  TaskSummary,
} from "@/lib/api";
import { resolveAssetUrl } from "@/lib/api";
import { cn } from "@/lib/utils";

type ReviewPenItem = {
  taskId: number;
  orgId: number;
  buildingId: number;
  buildingName: string;
  mediaId: number;
  penId: number;
  penName: string;
  mediaType: string;
  count: number;
  manualCount: number;
  picturePath: string;
  outputPicturePath: string;
  thumbnailPath: string;
  processingStatus: string;
  processingMessage: string;
  status: boolean;
};

function parseNumber(raw: string) {
  const value = Number(raw);
  return Number.isFinite(value) ? value : 0;
}

function todayDate() {
  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, "0");
  const dd = String(now.getDate()).padStart(2, "0");
  return `${yyyy}-${mm}-${dd}`;
}

function toDateOnly(value?: string | null) {
  return (value || "").trim().slice(0, 10);
}

function listDatesBetween(start: string, end: string) {
  const startDate = new Date(`${start}T00:00:00`);
  const endDate = new Date(`${end}T00:00:00`);
  if (Number.isNaN(startDate.getTime()) || Number.isNaN(endDate.getTime())) {
    return [todayDate()];
  }

  const safeStart = startDate <= endDate ? startDate : endDate;
  const safeEnd = startDate <= endDate ? endDate : startDate;
  const dates: string[] = [];
  const cursor = new Date(safeStart);

  while (cursor <= safeEnd) {
    const yyyy = cursor.getFullYear();
    const mm = String(cursor.getMonth() + 1).padStart(2, "0");
    const dd = String(cursor.getDate()).padStart(2, "0");
    dates.push(`${yyyy}-${mm}-${dd}`);
    cursor.setDate(cursor.getDate() + 1);
  }

  return dates.length ? dates : [todayDate()];
}

function normalizeReviewItems(task: TaskDetail | null): ReviewPenItem[] {
  if (!task) return [];
  return task.buildings.flatMap((building) =>
    building.pens
      .filter(
        (pen) =>
          (pen.mediaId ?? 0) > 0 ||
          Boolean(pen.picturePath) ||
          Boolean(pen.outputPicturePath) ||
          Boolean(pen.processingStatus),
      )
      .map((pen) => ({
        taskId: task.id,
        orgId: task.orgId,
        buildingId: building.buildingId,
        buildingName: building.buildingName,
        mediaId: pen.mediaId ?? 0,
        penId: pen.penId,
        penName: pen.penName,
        mediaType: pen.mediaType,
        count: pen.count,
        manualCount: pen.manualCount,
        picturePath: pen.picturePath,
        outputPicturePath: pen.outputPicturePath,
        thumbnailPath: pen.thumbnailPath,
        processingStatus: pen.processingStatus,
        processingMessage: pen.processingMessage,
        status: pen.status,
      })),
  );
}

function toMediaRecord(item: ReviewPenItem): MediaRecord {
  return {
    id: item.mediaId,
    mediaId: item.mediaId,
    taskId: item.taskId,
    orgId: item.orgId,
    penId: item.penId,
    mediaType: item.mediaType,
    picturePath: item.picturePath,
    outputPicturePath: item.outputPicturePath,
    thumbnailPath: item.thumbnailPath,
    time: "",
    captureTime: "",
    dayBucket: "",
    count: item.count,
    manualCount: item.manualCount,
    processingStatus: item.processingStatus,
    processingMessage: item.processingMessage,
    status: item.status,
    duplicate: false,
    analysisJson: "",
  };
}

function resolveMediaId(media: MediaRecord | null | undefined) {
  if (!media) return 0;
  return Number(media.mediaId || media.id || 0);
}

function mediaTimestamp(media: MediaRecord) {
  const raw = media.captureTime || media.time || media.dayBucket || "";
  if (!raw) return 0;
  const normalized = raw.includes("T") ? raw : raw.replace(" ", "T");
  const value = Date.parse(normalized);
  return Number.isNaN(value) ? 0 : value;
}

function sortAndDedupeMedia(records: MediaRecord[]) {
  const map = new Map<number, MediaRecord>();
  records.forEach((media) => {
    const key = resolveMediaId(media);
    if (!key) return;
    const existing = map.get(key);
    if (!existing || mediaTimestamp(media) >= mediaTimestamp(existing)) {
      map.set(key, media);
    }
  });
  return Array.from(map.values()).sort((left, right) => {
    const timeDiff = mediaTimestamp(right) - mediaTimestamp(left);
    if (timeDiff !== 0) return timeDiff;
    return resolveMediaId(right) - resolveMediaId(left);
  });
}

function mediaStatusText(media: MediaRecord) {
  if (media.status) return "已确认";
  const normalized = (media.processingStatus || "").toUpperCase();
  if (normalized === "FAILED") return "处理失败";
  if (normalized === "PROCESSING" || normalized === "PENDING") {
    return "处理中";
  }
  return "待复核";
}

export function ReviewSection({
  api,
  notify,
}: {
  api: AdminApi;
  notify: (notice: Notice) => void;
}) {
  const runAction = useApiRunner(notify);

  const [buildingTree, setBuildingTree] = useState<BuildingTree | null>(null);
  const [taskList, setTaskList] = useState<TaskSummary[]>([]);
  const [taskDetailId, setTaskDetailId] = useState("");
  const [reviewTask, setReviewTask] = useState<TaskDetail | null>(null);
  const [reviewActionOpen, setReviewActionOpen] = useState(false);
  const [selectedReviewPen, setSelectedReviewPen] =
    useState<ReviewPenItem | null>(null);
  const [reviewMediaList, setReviewMediaList] = useState<MediaRecord[]>([]);
  const [reviewMediaLoading, setReviewMediaLoading] = useState(false);
  const [selectedReviewMediaId, setSelectedReviewMediaId] = useState("");
  const [manualCount, setManualCount] = useState("");
  const [deadPigPenId, setDeadPigPenId] = useState("");
  const [deadPigDate, setDeadPigDate] = useState(todayDate());
  const [deadPigList, setDeadPigList] = useState<DeadPigReport[]>([]);
  const [selectedDeadPig, setSelectedDeadPig] = useState<DeadPigReport | null>(
    null,
  );
  const [deadPigDetailOpen, setDeadPigDetailOpen] = useState(false);

  const reviewItems = normalizeReviewItems(reviewTask);
  const confirmedCount = reviewItems.filter((item) => item.status).length;
  const processingCount = reviewItems.filter((item) =>
    ["PENDING", "PROCESSING"].includes(item.processingStatus.toUpperCase()),
  ).length;
  const selectedReviewMedia = useMemo(() => {
    const fromList = reviewMediaList.find(
      (item) => String(resolveMediaId(item)) === selectedReviewMediaId,
    );
    if (fromList) return fromList;
    if (reviewMediaList.length > 0) return reviewMediaList[0];
    return selectedReviewPen ? toMediaRecord(selectedReviewPen) : null;
  }, [reviewMediaList, selectedReviewMediaId, selectedReviewPen]);
  const deadPigPenOptions = useMemo(() => {
    if (reviewTask) {
      return reviewTask.buildings.flatMap((building) =>
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
  }, [buildingTree, reviewTask]);

  async function loadTaskPage() {
    await runAction(() => api.getTaskPage(1, 30), {
      onData: (value) => setTaskList(value.list),
    });
  }

  async function loadBuildingTree() {
    await runAction(() => api.getBuildingCurrent(), {
      onData: (value) => setBuildingTree(value),
    });
  }

  async function loadReviewTask(targetId?: number) {
    const taskId = targetId ?? parseNumber(taskDetailId);
    if (!taskId) {
      notify({ type: "error", text: "请选择任务" });
      return;
    }
    const result = await runAction(() => api.getTaskDetail(taskId), {
      onData: (value) => {
        setReviewTask(value);
        const taskDate =
          toDateOnly(value.endTime) ||
          toDateOnly(value.startTime) ||
          todayDate();
        const taskPenIds = new Set(
          value.buildings.flatMap((building) =>
            building.pens.map((pen) => pen.penId),
          ),
        );
        const firstPenId = value.buildings[0]?.pens[0]?.penId ?? 0;
        setDeadPigDate(taskDate);
        setDeadPigPenId((current) => {
          const currentId = parseNumber(current);
          if (currentId && taskPenIds.has(currentId)) {
            return current;
          }
          return firstPenId ? String(firstPenId) : "";
        });
      },
    });
    if (result !== undefined) {
      setTaskDetailId(String(taskId));
    }
  }

  async function refreshCurrentReviewTask() {
    if (reviewTask?.id) {
      await loadReviewTask(reviewTask.id);
      return;
    }
    await loadTaskPage();
  }

  async function loadReviewMediaForPen(item: ReviewPenItem) {
    const fallback = item.mediaId > 0 ? [toMediaRecord(item)] : [];
    const range = reviewTask
      ? listDatesBetween(
          toDateOnly(reviewTask.startTime) || todayDate(),
          toDateOnly(reviewTask.endTime) || todayDate(),
        )
      : [todayDate()];

    setReviewMediaLoading(true);
    try {
      const responses = await Promise.all(
        range.map((date) => api.getMediaLibrary(item.penId, date)),
      );
      const media = sortAndDedupeMedia(
        responses
          .filter((response) => response.ok)
          .flatMap((response) => response.data)
          .filter(
            (record) =>
              record.penId === item.penId &&
              (record.taskId <= 0 || record.taskId === item.taskId),
          ),
      );
      const nextList = media.length ? media : fallback;
      setReviewMediaList(nextList);
      const preferred =
        nextList.find((record) => !record.status) || nextList[0];
      setSelectedReviewMediaId(
        preferred ? String(resolveMediaId(preferred)) : "",
      );
      setManualCount(
        preferred
          ? String(
              preferred.manualCount > 0
                ? preferred.manualCount
                : preferred.count,
            )
          : "",
      );
    } catch {
      setReviewMediaList(fallback);
      setSelectedReviewMediaId(
        fallback[0] ? String(resolveMediaId(fallback[0])) : "",
      );
      setManualCount(
        fallback[0]
          ? String(
              fallback[0].manualCount > 0
                ? fallback[0].manualCount
                : fallback[0].count,
            )
          : "",
      );
      notify({
        type: "error",
        text: "加载媒体库失败，暂时仅展示任务详情返回的最新媒体",
      });
    } finally {
      setReviewMediaLoading(false);
    }
  }

  function closeReviewAction() {
    setReviewActionOpen(false);
    setSelectedReviewPen(null);
    setReviewMediaList([]);
    setSelectedReviewMediaId("");
    setManualCount("");
  }

  function openReviewAction(item: ReviewPenItem) {
    setSelectedReviewPen(item);
    setReviewActionOpen(true);
    if (item.mediaId > 0) {
      setReviewMediaList([toMediaRecord(item)]);
      setSelectedReviewMediaId(String(item.mediaId));
    } else {
      setReviewMediaList([]);
      setSelectedReviewMediaId("");
    }
    setManualCount(
      String(item.manualCount > 0 ? item.manualCount : item.count),
    );
    void loadReviewMediaForPen(item);
  }

  function selectReviewMedia(media: MediaRecord) {
    setSelectedReviewMediaId(String(resolveMediaId(media)));
    setManualCount(
      String(media.manualCount > 0 ? media.manualCount : media.count),
    );
  }

  async function submitManualCount() {
    const mediaId = resolveMediaId(selectedReviewMedia);
    const count = parseNumber(manualCount);
    if (!mediaId) {
      notify({ type: "error", text: "请选择一条具体媒体后再提交人工改数" });
      return;
    }
    if (count <= 0) {
      notify({ type: "error", text: "请输入有效人工数量" });
      return;
    }
    const result = await runAction(() => api.manualCount(mediaId, count), {
      successText: selectedReviewPen?.penName?.trim()
        ? `栏舍「${selectedReviewPen.penName.trim()}」媒体已提交人工改数`
        : `媒体 #${mediaId} 人工改数已提交`,
    });
    if (result !== undefined) {
      closeReviewAction();
      emitAdminDataChanged("review-manual-count");
      void Promise.all([refreshCurrentReviewTask(), loadTaskPage()]);
    }
  }

  async function confirmSelectedMedia() {
    const mediaId = resolveMediaId(selectedReviewMedia);
    if (!mediaId) {
      notify({ type: "error", text: "请选择一条具体媒体后再确认" });
      return;
    }
    const result = await runAction(() => api.confirmMedia([mediaId]), {
      successText: selectedReviewPen?.penName?.trim()
        ? `栏舍「${selectedReviewPen.penName.trim()}」媒体已确认`
        : `媒体 #${mediaId} 已确认`,
    });
    if (result !== undefined) {
      closeReviewAction();
      emitAdminDataChanged("review-confirm-media");
      void Promise.all([refreshCurrentReviewTask(), loadTaskPage()]);
    }
  }

  async function reopenSelectedMedia() {
    const mediaId = resolveMediaId(selectedReviewMedia);
    if (!mediaId) {
      notify({ type: "error", text: "请选择一条具体媒体后再重新打开" });
      return;
    }
    const result = await runAction(() => api.unlockMedia([mediaId]), {
      successText: selectedReviewPen?.penName?.trim()
        ? `栏舍「${selectedReviewPen.penName.trim()}」媒体已重新打开`
        : `媒体 #${mediaId} 已重新打开`,
    });
    if (result !== undefined) {
      closeReviewAction();
      emitAdminDataChanged("review-unlock-media");
      void Promise.all([refreshCurrentReviewTask(), loadTaskPage()]);
    }
  }

  async function deleteSelectedMedia() {
    const mediaId = resolveMediaId(selectedReviewMedia);
    if (!mediaId) {
      notify({ type: "error", text: "请选择一条具体媒体后再删除" });
      return;
    }
    const result = await runAction(() => api.deleteMedia(mediaId), {
      successText: selectedReviewPen?.penName?.trim()
        ? `栏舍「${selectedReviewPen.penName.trim()}」媒体已删除`
        : `媒体 #${mediaId} 已删除`,
    });
    if (result !== undefined) {
      closeReviewAction();
      emitAdminDataChanged("review-delete-media");
      void Promise.all([refreshCurrentReviewTask(), loadTaskPage()]);
    }
  }

  async function loadDeadPigDaily() {
    const penId = parseNumber(deadPigPenId);
    if (!penId || !deadPigDate.trim()) {
      notify({ type: "error", text: "请选择栏舍和日期" });
      return;
    }
    await runAction(() => api.getDeadPigDaily(penId, deadPigDate.trim()), {
      onData: (value) => setDeadPigList(value),
    });
  }

  useEffect(() => {
    void Promise.all([loadTaskPage(), loadBuildingTree()]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    return subscribeAdminDataChanged(() => {
      void loadTaskPage();
      if (reviewTask?.id) {
        void loadReviewTask(reviewTask.id);
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [reviewTask?.id]);

  return (
    <div className="space-y-4">
      <SectionIntroCard
        eyebrow="任务复核"
        icon={ShieldCheck}
        title="任务媒体复核"
        description="按任务查看员工上传结果。每个栏舍可以展开查看整段任务周期内的全部媒体，再选择具体一条做改数、确认或重新打开。"
        stats={[
          { label: "任务数", value: taskList.length },
          { label: "当前任务媒体栏舍", value: reviewItems.length },
          { label: "已确认", value: confirmedCount },
          { label: "处理中", value: processingCount },
        ]}
      />

      <div className="grid gap-4 xl:grid-cols-[0.92fr_1.08fr]">
        <Card>
          <CardHeader>
            <CardTitle>选择任务</CardTitle>
            <CardDescription>
              先选任务，再查看该任务下员工已上传的媒体与复核状态。
            </CardDescription>
            <CardAction>
              <Button size="sm" variant="outline" onClick={loadTaskPage}>
                刷新任务
              </Button>
            </CardAction>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-center gap-2">
              <Select value={taskDetailId} onValueChange={setTaskDetailId}>
                <SelectTrigger className="w-72">
                  <SelectValue placeholder="选择任务后进入复核" />
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
              <Button
                variant="outline"
                disabled={!taskDetailId}
                onClick={() => void loadReviewTask()}
              >
                进入复核
              </Button>
            </div>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>ID</TableHead>
                  <TableHead>任务名称</TableHead>
                  <TableHead>员工ID</TableHead>
                  <TableHead>状态</TableHead>
                  <TableHead className="text-right">操作</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {taskList.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell>{item.id}</TableCell>
                    <TableCell className="max-w-52 truncate">
                      {item.taskName}
                    </TableCell>
                    <TableCell>{item.employeeId}</TableCell>
                    <TableCell>{taskStatusText(item.taskStatus)}</TableCell>
                    <TableCell className="text-right">
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => void loadReviewTask(item.id)}
                      >
                        进入复核
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>
              {reviewTask ? `任务 #${reviewTask.id} 复核` : "等待选择任务"}
            </CardTitle>
            <CardDescription>
              任务驱动的复核流程：员工上传，AI
              处理，管理员在弹窗里查看该栏舍的全部媒体，再选择具体一条做修正和确认。
            </CardDescription>
            {reviewTask ? (
              <CardAction className="flex flex-wrap gap-2">
                <Badge variant="outline">{reviewTask.taskName}</Badge>
                <Badge variant="secondary">
                  {taskStatusText(reviewTask.taskStatus)}
                </Badge>
              </CardAction>
            ) : null}
          </CardHeader>
          <CardContent className="space-y-4">
            {reviewTask ? (
              <>
                <div className="grid gap-3 sm:grid-cols-4">
                  <Metric
                    label="已上传栏舍"
                    value={reviewTask.uploadedPenCount}
                  />
                  <Metric
                    label="已确认栏舍"
                    value={reviewTask.confirmedPenCount}
                  />
                  <Metric
                    label="处理中栏舍"
                    value={reviewTask.processingPenCount}
                  />
                  <Metric label="处理失败" value={reviewTask.failedPenCount} />
                </div>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>楼栋</TableHead>
                      <TableHead>栏舍</TableHead>
                      <TableHead>最新媒体ID</TableHead>
                      <TableHead>AI数量</TableHead>
                      <TableHead>人工数量</TableHead>
                      <TableHead>处理状态</TableHead>
                      <TableHead>复核</TableHead>
                      <TableHead className="text-right">操作</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {reviewItems.map((item) => (
                      <TableRow key={`${item.buildingId}-${item.penId}`}>
                        <TableCell>
                          {item.buildingName || item.buildingId}
                        </TableCell>
                        <TableCell>{item.penName || item.penId}</TableCell>
                        <TableCell>{item.mediaId || "-"}</TableCell>
                        <TableCell>{item.count}</TableCell>
                        <TableCell>{item.manualCount}</TableCell>
                        <TableCell>
                          <StatusBadge
                            status={
                              item.processingStatus ||
                              (item.picturePath ? "UPLOADED" : "未上传")
                            }
                          />
                        </TableCell>
                        <TableCell>
                          {item.status ? "已确认" : "待确认"}
                        </TableCell>
                        <TableCell className="text-right">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => openReviewAction(item)}
                          >
                            复核
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
                {reviewItems.length === 0 ? (
                  <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
                    当前任务还没有可复核的上传媒体，通常意味着员工尚未上传，或
                    AI 还未回写结果。
                  </div>
                ) : null}
              </>
            ) : (
              <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
                从左侧任务列表进入后，这里会展示该任务下已上传的媒体。点击“复核”后，弹窗会继续拉取该栏舍在任务周期内的全部媒体记录。
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>死猪日报核对</CardTitle>
          <CardDescription>
            这里现在也支持任务上下文驱动。已选择任务时，栏舍范围会自动收敛到当前任务，日期默认带入任务结束日，再按栏舍和日期查询日报与关联媒体。
          </CardDescription>
          {reviewTask ? (
            <CardAction className="flex flex-wrap gap-2">
              <Badge variant="outline">当前任务：{reviewTask.taskName}</Badge>
              <Badge variant="secondary">
                {toDateOnly(reviewTask.startTime)} ~{" "}
                {toDateOnly(reviewTask.endTime)}
              </Badge>
            </CardAction>
          ) : null}
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="grid gap-3 md:grid-cols-[minmax(0,220px)_200px_auto]">
            <div className="space-y-1">
              <Label>栏舍</Label>
              <Select value={deadPigPenId} onValueChange={setDeadPigPenId}>
                <SelectTrigger>
                  <SelectValue placeholder="请选择栏舍" />
                </SelectTrigger>
                <SelectContent>
                  {deadPigPenOptions.map((pen) => (
                    <SelectItem key={pen.id} value={String(pen.id)}>
                      {pen.label} · {pen.buildingName}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1">
              <Label>日期</Label>
              <DateInput value={deadPigDate} onChange={setDeadPigDate} />
            </div>
            <Button
              className="self-end"
              variant="outline"
              onClick={() => void loadDeadPigDaily()}
            >
              查询死猪日报
            </Button>
          </div>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>上报单</TableHead>
                <TableHead>栏舍ID</TableHead>
                <TableHead>数量</TableHead>
                <TableHead>状态</TableHead>
                <TableHead>创建时间</TableHead>
                <TableHead className="text-right">操作</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {deadPigList.map((item) => (
                <TableRow key={item.reportId}>
                  <TableCell>{item.reportId}</TableCell>
                  <TableCell>{item.penId}</TableCell>
                  <TableCell>{item.quantity}</TableCell>
                  <TableCell>{item.status || "-"}</TableCell>
                  <TableCell>{item.createdAt || "-"}</TableCell>
                  <TableCell className="text-right">
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => {
                        setSelectedDeadPig(item);
                        setDeadPigDetailOpen(true);
                      }}
                    >
                      详情
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          {deadPigList.length === 0 ? (
            <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
              查询后这里会展示死猪上报记录和关联图片。
            </div>
          ) : null}
        </CardContent>
      </Card>

      <Dialog
        open={reviewActionOpen}
        onOpenChange={(open) => {
          if (!open) {
            closeReviewAction();
            return;
          }
          setReviewActionOpen(true);
        }}
      >
        <DialogContent className="sm:max-w-6xl">
          <DialogHeader>
            <DialogTitle>媒体复核</DialogTitle>
            <DialogDescription>
              先选中一条具体媒体，再进行人工改数、确认、重新打开或删除。图片支持点击放大查看细节。
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[72vh] space-y-4 overflow-y-auto pr-1">
            <div className="grid gap-4 xl:grid-cols-[0.8fr_1.2fr]">
              <Card className="border-border/70 shadow-none">
                <CardHeader>
                  <CardTitle>
                    {selectedReviewPen?.penName || "待选择栏舍媒体"}
                  </CardTitle>
                  <CardDescription>
                    {selectedReviewPen
                      ? `${selectedReviewPen.buildingName || selectedReviewPen.buildingId} · 当前栏舍在任务周期内的全部媒体记录`
                      : "请选择栏舍后查看媒体列表"}
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-3">
                  {reviewMediaLoading ? (
                    <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
                      正在加载该栏舍的媒体库...
                    </div>
                  ) : null}
                  {!reviewMediaLoading && reviewMediaList.length === 0 ? (
                    <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
                      当前栏舍没有找到媒体记录。
                    </div>
                  ) : null}
                  <div className="grid gap-3 md:grid-cols-2">
                    {reviewMediaList.map((media) => {
                      const mediaId = resolveMediaId(media);
                      const selected =
                        String(mediaId) === selectedReviewMediaId;
                      const previewSrc = resolveAssetUrl(
                        media.outputPicturePath ||
                          media.thumbnailPath ||
                          media.picturePath,
                      );
                      return (
                        <div
                          key={mediaId || `${media.penId}-${media.captureTime}`}
                          className={cn(
                            "rounded-2xl border bg-card p-3 transition-colors",
                            selected
                              ? "border-primary shadow-sm"
                              : "border-border/70",
                          )}
                        >
                          {previewSrc ? (
                            <ImageViewer
                              src={previewSrc}
                              alt={`媒体 ${mediaId}`}
                              className="h-40 w-full rounded-xl object-cover"
                              containerClassName="overflow-hidden rounded-xl"
                            />
                          ) : (
                            <div className="flex h-40 items-center justify-center rounded-xl border border-dashed text-sm text-muted-foreground">
                              暂无可预览图片
                            </div>
                          )}
                          <div className="mt-3 space-y-2">
                            <div className="flex flex-wrap items-center gap-2">
                              <Badge variant="secondary">
                                媒体 #{mediaId || "-"}
                              </Badge>
                              <StatusBadge
                                status={
                                  media.processingStatus ||
                                  mediaStatusText(media)
                                }
                              />
                              <Badge
                                variant={media.status ? "default" : "outline"}
                              >
                                {media.status ? "已确认" : "待确认"}
                              </Badge>
                            </div>
                            <div className="text-sm text-muted-foreground">
                              数量{" "}
                              {media.manualCount > 0
                                ? media.manualCount
                                : media.count}{" "}
                              · 采集时间{" "}
                              {media.captureTime ||
                                media.time ||
                                media.dayBucket ||
                                "-"}
                            </div>
                            <Button
                              className="w-full"
                              size="sm"
                              variant={selected ? "default" : "outline"}
                              onClick={() => selectReviewMedia(media)}
                            >
                              {selected ? "当前已选中" : "查看这条媒体"}
                            </Button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              </Card>

              <MediaDetailCard media={selectedReviewMedia} />
            </div>

            <div className="rounded-2xl border bg-card p-4 shadow-none">
              <div className="grid gap-3 md:grid-cols-[1fr_auto_auto_auto]">
                <div className="space-y-1">
                  <Label>人工修正数量</Label>
                  <Input
                    value={manualCount}
                    onChange={(event) => setManualCount(event.target.value)}
                    placeholder="请输入人工盘点数量"
                  />
                </div>
                <Button
                  className="self-end"
                  disabled={!resolveMediaId(selectedReviewMedia)}
                  onClick={() => void submitManualCount()}
                >
                  提交改数
                </Button>
                <Button
                  variant="outline"
                  className="self-end"
                  disabled={!resolveMediaId(selectedReviewMedia)}
                  onClick={() => void reopenSelectedMedia()}
                >
                  重新打开
                </Button>
                <Button
                  variant="destructive"
                  className="self-end"
                  disabled={!resolveMediaId(selectedReviewMedia)}
                  onClick={() => void deleteSelectedMedia()}
                >
                  删除媒体
                </Button>
              </div>
              <div className="mt-3 flex flex-wrap items-center gap-2">
                <Badge
                  variant={selectedReviewMedia?.status ? "default" : "outline"}
                >
                  {selectedReviewMedia?.status ? "当前已确认" : "当前待确认"}
                </Badge>
                <Button
                  disabled={!resolveMediaId(selectedReviewMedia)}
                  onClick={() => void confirmSelectedMedia()}
                >
                  确认媒体
                </Button>
                <span className="text-sm text-muted-foreground">
                  {resolveMediaId(selectedReviewMedia)
                    ? `当前操作媒体 ID：${resolveMediaId(selectedReviewMedia)}`
                    : "请先从左侧列表选择一条具体媒体"}
                </span>
              </div>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      <Dialog open={deadPigDetailOpen} onOpenChange={setDeadPigDetailOpen}>
        <DialogContent className="sm:max-w-4xl">
          <DialogHeader>
            <DialogTitle>死猪日报详情</DialogTitle>
            <DialogDescription>
              查看上报信息、备注和关联媒体。
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[72vh] overflow-y-auto pr-1">
            <DeadPigDetailCard report={selectedDeadPig} />
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function Metric({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-xl border border-border/70 bg-muted/20 p-3">
      <div className="text-xs text-muted-foreground">{label}</div>
      <div className="mt-1 text-lg font-semibold">{value}</div>
    </div>
  );
}
