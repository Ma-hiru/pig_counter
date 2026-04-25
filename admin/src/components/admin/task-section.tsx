"use client";

import { useEffect, useState } from "react";

import { ClipboardList } from "lucide-react";

import {
  emitAdminDataChanged,
  subscribeAdminDataChanged,
} from "@/components/admin/data-events";
import { DateTimeInput } from "@/components/admin/date-input";
import { SectionIntroCard } from "@/components/admin/section-intro-card";
import {
  TaskDetailPanel,
  taskStatusText,
} from "@/components/admin/task-detail-panel";
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
import { Checkbox } from "@/components/ui/checkbox";
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
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
  EmployeeRecord,
  TaskCreatePayload,
  TaskDetail,
  TaskSummary,
} from "@/lib/api";

function pad2(value: number) {
  return String(value).padStart(2, "0");
}

function formatDateTimeInput(input: Date) {
  return `${input.getFullYear()}-${pad2(input.getMonth() + 1)}-${pad2(input.getDate())}T${pad2(input.getHours())}:${pad2(input.getMinutes())}`;
}

function toApiDateTime(input: string) {
  const trimmed = input.trim();
  if (!trimmed) return "";
  const [datePart, timePart = "00:00"] = trimmed.split("T");
  return `${datePart} ${timePart}:00`;
}

function parseNumber(raw: string) {
  const value = Number(raw);
  return Number.isFinite(value) ? value : 0;
}

function defaultTaskTimes() {
  const start = new Date();
  const end = new Date(Date.now() + 8 * 60 * 60 * 1000);
  return {
    startTime: formatDateTimeInput(start),
    endTime: formatDateTimeInput(end),
  };
}

export function TaskSection({
  api,
  notify,
}: {
  api: AdminApi;
  notify: (notice: Notice) => void;
}) {
  const runAction = useApiRunner(notify);

  const [taskList, setTaskList] = useState<TaskSummary[]>([]);
  const [taskLookupId, setTaskLookupId] = useState("");
  const [taskDetail, setTaskDetail] = useState<TaskDetail | null>(null);
  const [taskDetailOpen, setTaskDetailOpen] = useState(false);
  const [taskDeleteOpen, setTaskDeleteOpen] = useState(false);
  const [taskDeleteTarget, setTaskDeleteTarget] = useState<{
    id: number;
    taskName: string;
  } | null>(null);

  const [buildingTree, setBuildingTree] = useState<BuildingTree | null>(null);
  const [employeeList, setEmployeeList] = useState<EmployeeRecord[]>([]);

  const [taskDialogOpen, setTaskDialogOpen] = useState(false);
  const [taskName, setTaskName] = useState("");
  const [employeeId, setEmployeeId] = useState("");
  const [startTime, setStartTime] = useState(
    () => defaultTaskTimes().startTime,
  );
  const [endTime, setEndTime] = useState(() => defaultTaskTimes().endTime);
  const [selectedPensByBuilding, setSelectedPensByBuilding] = useState<
    Record<number, number[]>
  >({});

  const selectedBuildingCount = Object.values(selectedPensByBuilding).filter(
    (pens) => pens.length > 0,
  ).length;
  const selectedPenCount = Object.values(selectedPensByBuilding).reduce(
    (sum, pens) => sum + pens.length,
    0,
  );

  async function loadTaskPage() {
    await runAction(() => api.getTaskPage(1, 30), {
      onData: (value) => setTaskList(value.list),
    });
  }

  async function loadTaskDetail(targetId?: number) {
    const taskId = targetId ?? parseNumber(taskLookupId);
    if (!taskId) {
      notify({ type: "error", text: "请选择任务" });
      return;
    }
    const result = await runAction(() => api.getTaskDetail(taskId), {
      onData: (value) => setTaskDetail(value),
    });
    if (result !== undefined) {
      setTaskLookupId(String(taskId));
      setTaskDetailOpen(true);
    }
  }

  function openTaskDeleteDialog(task: { id: number; taskName: string }) {
    setTaskDeleteTarget(task);
    setTaskDeleteOpen(true);
  }

  async function loadCreateDependencies() {
    await Promise.all([
      runAction(() => api.getBuildingCurrent(), {
        onData: (value) => setBuildingTree(value),
      }),
      runAction(() => api.getUserPage(1, 100), {
        onData: (value) => setEmployeeList(value.list),
      }),
    ]);
  }

  function togglePen(buildingId: number, penId: number, checked: boolean) {
    setSelectedPensByBuilding((prev) => {
      const currentPens = prev[buildingId] || [];
      const nextPens = checked
        ? Array.from(new Set([...currentPens, penId]))
        : currentPens.filter((item) => item !== penId);
      if (nextPens.length === 0) {
        const next = { ...prev };
        delete next[buildingId];
        return next;
      }
      return {
        ...prev,
        [buildingId]: nextPens,
      };
    });
  }

  function toggleBuilding(
    buildingId: number,
    penIds: number[],
    checked: boolean,
  ) {
    setSelectedPensByBuilding((prev) => {
      if (!checked) {
        const next = { ...prev };
        delete next[buildingId];
        return next;
      }
      return {
        ...prev,
        [buildingId]: penIds,
      };
    });
  }

  async function openTaskCreateDialog() {
    const defaults = defaultTaskTimes();
    setTaskName("");
    setEmployeeId("");
    setSelectedPensByBuilding({});
    setStartTime(defaults.startTime);
    setEndTime(defaults.endTime);
    setTaskDialogOpen(true);
    await loadCreateDependencies();
  }

  async function submitTask() {
    const finalEmployeeId = parseNumber(employeeId);
    const selectedBuildings = Object.entries(selectedPensByBuilding)
      .map(([buildingId, pens]) => ({
        buildingId: Number(buildingId),
        pens: pens
          .filter((penId) => Number.isFinite(penId) && penId > 0)
          .map((penId) => ({ penId })),
      }))
      .filter((item) => item.buildingId > 0 && item.pens.length > 0);
    if (!taskName.trim()) {
      notify({ type: "error", text: "任务名称不能为空" });
      return;
    }
    if (!finalEmployeeId || selectedBuildings.length === 0) {
      notify({ type: "error", text: "请选择员工，并至少勾选一个楼栋下的栏舍" });
      return;
    }

    const payload: TaskCreatePayload = {
      employeeId: finalEmployeeId,
      taskName: taskName.trim(),
      startTime: toApiDateTime(startTime),
      endTime: toApiDateTime(endTime),
      buildings: selectedBuildings,
    };

    const result = await runAction(() => api.addTask(payload), {
      successText: `任务「${payload.taskName}」已创建`,
    });
    if (result !== undefined) {
      setTaskDialogOpen(false);
      emitAdminDataChanged("task-created");
      void loadTaskPage();
    }
  }

  async function deleteTask() {
    const taskId = taskDeleteTarget?.id ?? 0;
    if (!taskId) {
      notify({ type: "error", text: "请选择要删除的任务" });
      return;
    }

    const result = await runAction(() => api.deleteTask(taskId), {
      successText: taskDeleteTarget?.taskName?.trim()
        ? `任务「${taskDeleteTarget.taskName.trim()}」已删除`
        : "任务已删除",
    });
    if (result !== undefined) {
      setTaskDeleteOpen(false);
      setTaskDeleteTarget(null);
      if (taskDetail?.id === taskId) {
        setTaskDetail(null);
        setTaskDetailOpen(false);
      }
      if (taskLookupId === String(taskId)) {
        setTaskLookupId("");
      }
      emitAdminDataChanged("task-deleted");
      void loadTaskPage();
    }
  }

  useEffect(() => {
    void Promise.all([loadTaskPage(), loadCreateDependencies()]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    return subscribeAdminDataChanged(() => {
      void loadTaskPage();
      if (taskDetail?.id) {
        void loadTaskDetail(taskDetail.id);
      }
      if (taskDialogOpen) {
        void loadCreateDependencies();
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [taskDetail?.id, taskDialogOpen]);

  return (
    <div className="space-y-4">
      <SectionIntroCard
        eyebrow="任务流转"
        icon={ClipboardList}
        title="任务管理"
        description="面向员工下发盘点任务，按多个楼栋和栏舍组织执行范围，并持续跟踪上传、处理和确认进度。"
        stats={[
          { label: "任务数", value: taskList.length },
          { label: "可选员工", value: employeeList.length },
          { label: "楼栋数", value: buildingTree?.buildings.length ?? 0 },
          { label: "当前已选栏舍", value: selectedPenCount },
        ]}
      />

      <div className="grid gap-4 xl:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>创建任务</CardTitle>
            <CardDescription>
              点击按钮后在弹窗里选择员工、多个楼栋和对应栏舍并下发任务。
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-3 sm:grid-cols-3">
              <Badge variant="secondary" className="justify-center py-2">
                员工 {employeeList.length}
              </Badge>
              <Badge variant="secondary" className="justify-center py-2">
                楼栋 {buildingTree?.buildings.length ?? 0}
              </Badge>
              <Badge variant="secondary" className="justify-center py-2">
                已选 {selectedPenCount}
              </Badge>
            </div>
            <Button
              className="w-full"
              onClick={() => void openTaskCreateDialog()}
            >
              创建任务
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>任务列表</CardTitle>
            <CardDescription>
              跟踪任务状态，并通过弹窗查看执行详情。
            </CardDescription>
            <CardAction>
              <Button size="sm" variant="outline" onClick={loadTaskPage}>
                刷新任务
              </Button>
            </CardAction>
          </CardHeader>
          <CardContent className="space-y-3">
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
                    <TableCell className="max-w-48 truncate">
                      {item.taskName}
                    </TableCell>
                    <TableCell>{item.employeeId}</TableCell>
                    <TableCell>{taskStatusText(item.taskStatus)}</TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => void loadTaskDetail(item.id)}
                        >
                          详情
                        </Button>
                        <Button
                          size="sm"
                          variant="destructive"
                          onClick={() =>
                            openTaskDeleteDialog({
                              id: item.id,
                              taskName: item.taskName,
                            })
                          }
                        >
                          删除
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
            <div className="flex items-center gap-2">
              <Select value={taskLookupId} onValueChange={setTaskLookupId}>
                <SelectTrigger className="w-72">
                  <SelectValue placeholder="直接选择任务查看详情" />
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
                disabled={!taskLookupId}
                onClick={() => void loadTaskDetail()}
              >
                打开详情
              </Button>
            </div>
            <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
              任务详情已改为弹窗展示。点击列表中的“详情”或直接从下拉框选择任务即可打开。
            </div>
          </CardContent>
        </Card>
      </div>

      <Dialog open={taskDialogOpen} onOpenChange={setTaskDialogOpen}>
        <DialogContent className="sm:max-w-3xl">
          <DialogHeader>
            <DialogTitle>创建任务</DialogTitle>
            <DialogDescription>
              选择执行员工、任务时间，以及多个楼栋下的目标栏舍后下发盘点任务。
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[68vh] space-y-4 overflow-y-auto pr-1">
            <div className="space-y-1">
              <Label>任务名称</Label>
              <Input
                value={taskName}
                onChange={(event) => setTaskName(event.target.value)}
                placeholder="例如：4月第4周盘点任务"
              />
            </div>
            <div className="grid gap-3 md:grid-cols-2">
              <div className="space-y-1">
                <Label>开始时间</Label>
                <DateTimeInput value={startTime} onChange={setStartTime} />
              </div>
              <div className="space-y-1">
                <Label>结束时间</Label>
                <DateTimeInput value={endTime} onChange={setEndTime} />
              </div>
            </div>
            <div className="grid gap-3 md:grid-cols-2">
              <div className="space-y-1">
                <Label>执行员工</Label>
                <Select value={employeeId} onValueChange={setEmployeeId}>
                  <SelectTrigger>
                    <SelectValue placeholder="请选择员工" />
                  </SelectTrigger>
                  <SelectContent>
                    {employeeList.map((item) => (
                      <SelectItem key={item.id} value={String(item.id)}>
                        {item.name || item.username}（ID: {item.id}）
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="space-y-2 rounded-lg border border-border/70 p-3">
              <div className="flex items-center justify-between gap-2">
                <div className="text-sm font-medium">楼栋与栏舍树形选择</div>
                <Badge variant="outline">
                  已选 {selectedBuildingCount} 栋 / {selectedPenCount} 个栏舍
                </Badge>
              </div>
              {(buildingTree?.buildings || []).length ? (
                <div className="space-y-3">
                  {(buildingTree?.buildings || []).map((building) => {
                    const selectedPens =
                      selectedPensByBuilding[building.id] || [];
                    const allPenIds = building.pens.map((pen) => pen.id);
                    const allChecked =
                      allPenIds.length > 0 &&
                      selectedPens.length === allPenIds.length;
                    const partialChecked =
                      selectedPens.length > 0 &&
                      selectedPens.length < allPenIds.length;
                    return (
                      <div
                        key={building.id}
                        className="rounded-xl border border-border/70 bg-muted/15 p-3"
                      >
                        <label className="flex items-center gap-2 rounded-lg border border-border/60 bg-background/80 px-3 py-2 text-sm">
                          <Checkbox
                            checked={allChecked || partialChecked}
                            onCheckedChange={(next) =>
                              toggleBuilding(
                                building.id,
                                allPenIds,
                                Boolean(next),
                              )
                            }
                          />
                          <div className="min-w-0 flex-1">
                            <div className="font-medium">
                              {building.name}（#{building.id}）
                            </div>
                            <div className="text-xs text-muted-foreground">
                              {building.code || "未设置编码"} · 共{" "}
                              {building.pens.length} 个栏舍
                            </div>
                          </div>
                          <Badge
                            variant={partialChecked ? "secondary" : "outline"}
                          >
                            已选 {selectedPens.length}
                          </Badge>
                        </label>
                        <div className="mt-3 ml-3 border-l border-border/60 pl-4">
                          <div className="grid gap-2 md:grid-cols-2">
                            {building.pens.map((pen) => {
                              const checked = selectedPens.includes(pen.id);
                              return (
                                <label
                                  key={pen.id}
                                  className="flex items-center gap-2 rounded-md border border-border/60 bg-background/70 px-2 py-1.5 text-sm"
                                >
                                  <Checkbox
                                    checked={checked}
                                    onCheckedChange={(next) =>
                                      togglePen(
                                        building.id,
                                        pen.id,
                                        Boolean(next),
                                      )
                                    }
                                  />
                                  <span>{pen.name}</span>
                                  <span className="ml-auto text-xs text-muted-foreground">
                                    #{pen.id}
                                  </span>
                                </label>
                              );
                            })}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="text-xs text-muted-foreground">
                  当前组织还没有可分配的楼栋和栏舍
                </div>
              )}
            </div>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">取消</Button>
            </DialogClose>
            <Button variant="outline" onClick={loadCreateDependencies}>
              刷新主数据
            </Button>
            <Button onClick={submitTask}>创建任务</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={taskDetailOpen} onOpenChange={setTaskDetailOpen}>
        <DialogContent className="sm:max-w-5xl">
          <DialogHeader>
            <DialogTitle>任务详情</DialogTitle>
            <DialogDescription>
              展示任务进度、楼栋栏舍明细与当前媒体处理状态。
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[72vh] overflow-y-auto pr-1">
            <TaskDetailPanel task={taskDetail} />
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">关闭</Button>
            </DialogClose>
            <Button
              variant="destructive"
              disabled={!taskDetail}
              onClick={() =>
                taskDetail
                  ? openTaskDeleteDialog({
                      id: taskDetail.id,
                      taskName: taskDetail.taskName,
                    })
                  : undefined
              }
            >
              删除任务
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog
        open={taskDeleteOpen}
        onOpenChange={(open) => {
          setTaskDeleteOpen(open);
          if (!open) {
            setTaskDeleteTarget(null);
          }
        }}
      >
        <DialogContent className="sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>删除任务</DialogTitle>
            <DialogDescription>
              删除后，任务本身、任务分配关系、该任务下的盘点媒体和相关缓存都会被一并清理。
            </DialogDescription>
          </DialogHeader>
          <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-4 text-sm text-muted-foreground">
            {taskDeleteTarget
              ? `即将删除任务 #${taskDeleteTarget.id} ${taskDeleteTarget.taskName ? `「${taskDeleteTarget.taskName}」` : ""}。此操作不可恢复，请确认当前任务确实需要作废。`
              : "请选择要删除的任务。"}
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button
                variant="outline"
                onClick={() => setTaskDeleteTarget(null)}
              >
                取消
              </Button>
            </DialogClose>
            <Button variant="destructive" onClick={deleteTask}>
              确认删除
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
