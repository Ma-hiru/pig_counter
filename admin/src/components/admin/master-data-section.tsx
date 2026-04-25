"use client";

import { useEffect, useState } from "react";

import { Database } from "lucide-react";

import { BuildingTreePanel } from "@/components/admin/building-tree-panel";
import {
  EmployeeDetailCard,
  PenDetailCard,
} from "@/components/admin/entity-detail-cards";
import { SectionIntroCard } from "@/components/admin/section-intro-card";
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
import { Switch } from "@/components/ui/switch";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import type {
  AdminApi,
  ApiFieldErrors,
  BuildingRecord,
  BuildingTree,
  EmployeeRecord,
  LoginUser,
  OrgRecord,
  PenRecord,
} from "@/lib/api";

function FieldError({ message }: { message?: string }) {
  return (
    <p className="min-h-4 text-xs leading-4 text-destructive">
      {message ?? ""}
    </p>
  );
}

function toSafeNumber(raw: string) {
  const value = Number(raw);
  return Number.isFinite(value) ? value : 0;
}

function toSafeIds(raw: string) {
  return raw
    .split(",")
    .map((item) => Number(item.trim()))
    .filter((item) => Number.isFinite(item) && item > 0);
}

export function MasterDataSection({
  api,
  profile,
  notify,
}: {
  api: AdminApi;
  profile: LoginUser;
  notify: (notice: Notice) => void;
}) {
  const runAction = useApiRunner(notify);

  const [orgList, setOrgList] = useState<OrgRecord[]>([]);

  const [employeeList, setEmployeeList] = useState<EmployeeRecord[]>([]);
  const [employeeForm, setEmployeeForm] = useState({
    id: "",
    username: "",
    password: "",
    name: "",
    sex: "男",
    phone: "",
    admin: false,
    picture: null as File | null,
  });
  const [employeeFieldErrors, setEmployeeFieldErrors] =
    useState<ApiFieldErrors>({});
  const [employeeDialogOpen, setEmployeeDialogOpen] = useState(false);
  const [employeeQueryOpen, setEmployeeQueryOpen] = useState(false);
  const [employeeDetailOpen, setEmployeeDetailOpen] = useState(false);
  const [employeeDeleteOpen, setEmployeeDeleteOpen] = useState(false);
  const [employeeBatchDeleteOpen, setEmployeeBatchDeleteOpen] = useState(false);
  const [employeeSearchName, setEmployeeSearchName] = useState("");
  const [employeeDetailId, setEmployeeDetailId] = useState("");
  const [employeeBatchDeleteIds, setEmployeeBatchDeleteIds] = useState("");
  const [employeeDetail, setEmployeeDetail] = useState<EmployeeRecord | null>(
    null,
  );
  const [employeeDeleteTarget, setEmployeeDeleteTarget] =
    useState<EmployeeRecord | null>(null);

  const [buildingTree, setBuildingTree] = useState<BuildingTree | null>(null);
  const [buildingList, setBuildingList] = useState<BuildingRecord[]>([]);
  const [buildingDialogOpen, setBuildingDialogOpen] = useState(false);
  const [buildingDeleteOpen, setBuildingDeleteOpen] = useState(false);
  const [buildingForm, setBuildingForm] = useState({
    id: "",
    buildingCode: "",
    buildingName: "",
  });
  const [buildingDeleteTarget, setBuildingDeleteTarget] =
    useState<BuildingRecord | null>(null);

  const [penDialogOpen, setPenDialogOpen] = useState(false);
  const [penDetailOpen, setPenDetailOpen] = useState(false);
  const [penDeleteOpen, setPenDeleteOpen] = useState(false);
  const [penForm, setPenForm] = useState({
    id: "",
    buildingId: "",
    penCode: "",
    penName: "",
  });
  const [penDeleteTarget, setPenDeleteTarget] = useState<{
    pen: PenRecord;
    buildingName?: string;
  } | null>(null);
  const [selectedPen, setSelectedPen] = useState<PenRecord | null>(null);
  const [selectedPenBuildingName, setSelectedPenBuildingName] = useState("");

  const currentOrg =
    orgList.find((item) => item.id === profile.orgId) ||
    orgList.find((item) => item.orgName === profile.organization) ||
    null;
  const organizationName =
    currentOrg?.orgName || profile.organization || `组织 ${profile.orgId}`;
  const visibleOrgList = orgList.filter(
    (item) =>
      item.id === profile.orgId || item.orgName === profile.organization,
  );
  const totalPenCount =
    buildingTree?.buildings.reduce((sum, item) => sum + item.pens.length, 0) ??
    0;

  async function loadOrgPage() {
    await runAction(() => api.getOrgPage(1, 20), {
      onData: (value) => setOrgList(value.list),
    });
  }

  async function loadEmployeePage() {
    await runAction(() => api.getUserPage(1, 30), {
      onData: (value) => setEmployeeList(value.list),
    });
  }

  function openEmployeeCreateDialog() {
    setEmployeeForm({
      id: "",
      username: "",
      password: "",
      name: "",
      sex: "男",
      phone: "",
      admin: false,
      picture: null,
    });
    setEmployeeFieldErrors({});
    setEmployeeDialogOpen(true);
  }

  function openEmployeeEditDialog(employee: EmployeeRecord) {
    setEmployeeForm({
      id: String(employee.id),
      username: employee.username || "",
      password: "",
      name: employee.name || "",
      sex: employee.sex || "男",
      phone: employee.phone || "",
      admin: Boolean(employee.admin),
      picture: null,
    });
    setEmployeeFieldErrors({});
    setEmployeeDialogOpen(true);
  }

  async function searchEmployees() {
    const result = await runAction(
      () =>
        api.searchUsers({
          name: employeeSearchName.trim(),
        }),
      {
        onData: (value) => setEmployeeList(value.list),
      },
    );
    if (result !== undefined) {
      setEmployeeQueryOpen(false);
    }
  }

  async function submitEmployeeForm() {
    if (!employeeForm.name.trim()) {
      setEmployeeFieldErrors({ name: "员工姓名不能为空" });
      return;
    }

    setEmployeeFieldErrors({});
    const payload = {
      name: employeeForm.name.trim(),
      sex: employeeForm.sex.trim() || "未知",
      phone: employeeForm.phone.trim(),
      admin: employeeForm.admin,
      picture: employeeForm.picture,
    };

    let result: null | undefined;
    if (employeeForm.id.trim()) {
      result = await runAction(
        () =>
          api.updateUser({
            ...payload,
            id: toSafeNumber(employeeForm.id),
          }),
        {
          successText: employeeForm.name.trim()
            ? `员工「${employeeForm.name.trim()}」已更新`
            : "员工已更新",
          onFieldErrors: setEmployeeFieldErrors,
        },
      );
    } else {
      if (!employeeForm.username.trim() || !employeeForm.password.trim()) {
        setEmployeeFieldErrors({
          username: employeeForm.username.trim() ? "" : "请输入账号",
          password: employeeForm.password.trim() ? "" : "请输入密码",
        });
        return;
      }
      result = await runAction(
        () =>
          api.registerUser({
            ...payload,
            username: employeeForm.username.trim(),
            password: employeeForm.password.trim(),
          }),
        {
          successText: employeeForm.name.trim()
            ? `员工「${employeeForm.name.trim()}」已创建`
            : "员工已创建",
          onFieldErrors: setEmployeeFieldErrors,
        },
      );
    }
    if (result !== undefined) {
      setEmployeeDialogOpen(false);
      void loadEmployeePage();
    }
  }

  async function deleteEmployee() {
    const id = employeeDeleteTarget?.id ?? 0;
    if (!id) {
      notify({ type: "error", text: "请选择要删除的员工" });
      return;
    }
    const result = await runAction(() => api.deleteUser(id), {
      successText: employeeDeleteTarget?.name?.trim()
        ? `员工「${employeeDeleteTarget.name.trim()}」已删除`
        : "员工已删除",
    });
    if (result !== undefined) {
      setEmployeeDeleteOpen(false);
      setEmployeeDeleteTarget(null);
      void loadEmployeePage();
    }
  }

  async function loadEmployeeDetail(targetId?: number) {
    const id = targetId ?? toSafeNumber(employeeDetailId);
    if (!id) {
      notify({ type: "error", text: "请选择员工" });
      return;
    }
    const result = await runAction(() => api.getUserDetail(id), {
      onData: (value) => setEmployeeDetail(value),
    });
    if (result !== undefined) {
      setEmployeeDetailId(String(id));
      setEmployeeQueryOpen(false);
      setEmployeeDetailOpen(true);
    }
  }

  async function deleteEmployeeBatch() {
    const ids = toSafeIds(employeeBatchDeleteIds);
    if (!ids.length) {
      notify({ type: "error", text: "请输入批量删除员工ID（逗号分隔）" });
      return;
    }
    const result = await runAction(() => api.deleteUsers(ids), {
      successText: `已删除 ${ids.length} 个员工`,
    });
    if (result !== undefined) {
      setEmployeeBatchDeleteOpen(false);
      setEmployeeBatchDeleteIds("");
      void loadEmployeePage();
    }
  }

  async function loadBuildingTree() {
    await runAction(() => api.getBuildingCurrent(), {
      onData: (value) => setBuildingTree(value),
    });
  }

  async function loadBuildingPage() {
    await runAction(() => api.getBuildingPage(1, 30), {
      onData: (value) => setBuildingList(value.list),
    });
  }

  function openBuildingDialog(building?: BuildingRecord) {
    setBuildingForm({
      id: building ? String(building.id) : "",
      buildingCode: building?.buildingCode || "",
      buildingName: building?.buildingName || "",
    });
    setBuildingDialogOpen(true);
  }

  async function submitBuildingForm() {
    if (
      !buildingForm.buildingCode.trim() ||
      !buildingForm.buildingName.trim()
    ) {
      notify({ type: "error", text: "楼栋编码和名称不能为空" });
      return;
    }
    if (buildingForm.id.trim()) {
      const result = await runAction(
        () =>
          api.updateBuilding({
            id: toSafeNumber(buildingForm.id),
            buildingCode: buildingForm.buildingCode.trim(),
            buildingName: buildingForm.buildingName.trim(),
          }),
        {
          successText: buildingForm.buildingName.trim()
            ? `楼栋「${buildingForm.buildingName.trim()}」已更新`
            : "楼栋已更新",
        },
      );
      if (result !== undefined) {
        setBuildingDialogOpen(false);
        void Promise.all([loadBuildingTree(), loadBuildingPage()]);
      }
    } else {
      const result = await runAction(
        () =>
          api.addBuilding({
            buildingCode: buildingForm.buildingCode.trim(),
            buildingName: buildingForm.buildingName.trim(),
          }),
        {
          successText: buildingForm.buildingName.trim()
            ? `楼栋「${buildingForm.buildingName.trim()}」已创建`
            : "楼栋已创建",
        },
      );
      if (result !== undefined) {
        setBuildingDialogOpen(false);
        void Promise.all([loadBuildingTree(), loadBuildingPage()]);
      }
    }
  }

  async function deleteBuilding() {
    const id = buildingDeleteTarget?.id ?? 0;
    if (!id) {
      notify({ type: "error", text: "请选择要删除的楼栋" });
      return;
    }
    const result = await runAction(() => api.deleteBuilding(id), {
      successText: buildingDeleteTarget?.buildingName?.trim()
        ? `楼栋「${buildingDeleteTarget.buildingName.trim()}」已删除`
        : "楼栋已删除",
    });
    if (result !== undefined) {
      setBuildingDeleteOpen(false);
      setBuildingDeleteTarget(null);
      void Promise.all([loadBuildingTree(), loadBuildingPage()]);
    }
  }

  function openPenDialog(pen?: PenRecord, buildingId?: number) {
    setPenForm({
      id: pen ? String(pen.id) : "",
      buildingId: pen
        ? String(pen.buildingId)
        : buildingId
          ? String(buildingId)
          : "",
      penCode: pen?.penCode || "",
      penName: pen?.penName || "",
    });
    setPenDialogOpen(true);
  }

  function openPenDetail(pen: PenRecord, buildingName?: string) {
    setSelectedPen(pen);
    setSelectedPenBuildingName(buildingName || "");
    setPenDetailOpen(true);
  }

  async function submitPenForm() {
    const buildingId = toSafeNumber(penForm.buildingId);
    if (!buildingId || !penForm.penCode.trim() || !penForm.penName.trim()) {
      notify({ type: "error", text: "栏舍必须选择所属楼栋并填写编码和名称" });
      return;
    }
    if (penForm.id.trim()) {
      const result = await runAction(
        () =>
          api.updatePen({
            id: toSafeNumber(penForm.id),
            buildingId,
            penCode: penForm.penCode.trim(),
            penName: penForm.penName.trim(),
          }),
        {
          successText: penForm.penName.trim()
            ? `栏舍「${penForm.penName.trim()}」已更新`
            : "栏舍已更新",
        },
      );
      if (result !== undefined) {
        setPenDialogOpen(false);
        void Promise.all([loadBuildingTree(), loadBuildingPage()]);
      }
    } else {
      const result = await runAction(
        () =>
          api.addPen({
            buildingId,
            penCode: penForm.penCode.trim(),
            penName: penForm.penName.trim(),
          }),
        {
          successText: penForm.penName.trim()
            ? `栏舍「${penForm.penName.trim()}」已创建`
            : "栏舍已创建",
        },
      );
      if (result !== undefined) {
        setPenDialogOpen(false);
        void Promise.all([loadBuildingTree(), loadBuildingPage()]);
      }
    }
  }

  async function deletePen() {
    const id = penDeleteTarget?.pen.id ?? 0;
    if (!id) {
      notify({ type: "error", text: "请选择要删除的栏舍" });
      return;
    }
    const result = await runAction(() => api.deletePen(id), {
      successText: penDeleteTarget?.pen.penName?.trim()
        ? `栏舍「${penDeleteTarget.pen.penName.trim()}」已删除`
        : "栏舍已删除",
    });
    if (result !== undefined) {
      setPenDeleteOpen(false);
      setPenDeleteTarget(null);
      void Promise.all([loadBuildingTree(), loadBuildingPage()]);
    }
  }

  useEffect(() => {
    void Promise.all([
      loadOrgPage(),
      loadEmployeePage(),
      loadBuildingTree(),
      loadBuildingPage(),
    ]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="space-y-4">
      <SectionIntroCard
        eyebrow="基础配置"
        icon={Database}
        title="主数据管理"
        description="管理员只管理自己的组织。组织信息只读，员工、楼栋、栏舍在当前组织范围内维护。"
        stats={[
          { label: "当前组织", value: organizationName },
          { label: "员工", value: employeeList.length },
          { label: "楼栋", value: buildingList.length },
          { label: "栏舍", value: totalPenCount },
        ]}
      />

      <Tabs defaultValue="org" className="space-y-4">
        <TabsList>
          <TabsTrigger value="org">组织</TabsTrigger>
          <TabsTrigger value="employee">员工</TabsTrigger>
          <TabsTrigger value="building">楼栋与栏舍</TabsTrigger>
        </TabsList>

        <TabsContent value="org">
          <Card>
            <CardHeader>
              <CardTitle>我的组织</CardTitle>
              <CardDescription>
                一个管理员对应一个组织，管理端不提供新增、修改或删除组织入口。
              </CardDescription>
              <CardAction>
                <Button size="sm" variant="outline" onClick={loadOrgPage}>
                  刷新组织信息
                </Button>
              </CardAction>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-3 md:grid-cols-4">
                <Card size="sm" className="shadow-none">
                  <CardContent className="p-3">
                    <div className="text-xs text-muted-foreground">组织ID</div>
                    <div className="mt-1 text-lg font-semibold">
                      {profile.orgId}
                    </div>
                  </CardContent>
                </Card>
                <Card size="sm" className="shadow-none md:col-span-2">
                  <CardContent className="p-3">
                    <div className="text-xs text-muted-foreground">
                      组织名称
                    </div>
                    <div className="mt-1 text-lg font-semibold">
                      {organizationName}
                    </div>
                  </CardContent>
                </Card>
                <Card size="sm" className="shadow-none">
                  <CardContent className="p-3">
                    <div className="text-xs text-muted-foreground">
                      图片去重窗口
                    </div>
                    <div className="mt-1 text-lg font-semibold">
                      {currentOrg?.photoDedupWindowDays ?? "-"} 天
                    </div>
                  </CardContent>
                </Card>
              </div>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>ID</TableHead>
                    <TableHead>编码</TableHead>
                    <TableHead>名称</TableHead>
                    <TableHead>负责人</TableHead>
                    <TableHead>电话</TableHead>
                    <TableHead>地址</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {visibleOrgList.map((item) => (
                    <TableRow key={item.id}>
                      <TableCell>{item.id}</TableCell>
                      <TableCell>{item.orgCode || "-"}</TableCell>
                      <TableCell>{item.orgName}</TableCell>
                      <TableCell>{item.adminName || "-"}</TableCell>
                      <TableCell>{item.tel || "-"}</TableCell>
                      <TableCell>{item.addr || "-"}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="employee">
          <Card>
            <CardHeader>
              <CardTitle>员工管理</CardTitle>
              <CardDescription>
                新增、修改和查询均在弹窗中完成，员工默认归属 {organizationName}
                。
              </CardDescription>
              <CardAction className="flex flex-wrap items-center gap-2">
                <Button size="sm" onClick={openEmployeeCreateDialog}>
                  新增员工
                </Button>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => setEmployeeQueryOpen(true)}
                >
                  查询员工
                </Button>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => setEmployeeBatchDeleteOpen(true)}
                >
                  批量删除
                </Button>
                <Button size="sm" variant="outline" onClick={loadEmployeePage}>
                  刷新
                </Button>
              </CardAction>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>ID</TableHead>
                    <TableHead>账号</TableHead>
                    <TableHead>姓名</TableHead>
                    <TableHead>组织</TableHead>
                    <TableHead>角色</TableHead>
                    <TableHead className="text-right">操作</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {employeeList.map((item) => (
                    <TableRow key={item.id}>
                      <TableCell>{item.id}</TableCell>
                      <TableCell>{item.username}</TableCell>
                      <TableCell>{item.name}</TableCell>
                      <TableCell>{item.organization || item.orgId}</TableCell>
                      <TableCell>
                        <Badge variant={item.admin ? "default" : "outline"}>
                          {item.admin ? "管理员" : "员工"}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex justify-end gap-2">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => void loadEmployeeDetail(item.id)}
                          >
                            详情
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => openEmployeeEditDialog(item)}
                          >
                            修改
                          </Button>
                          <Button
                            size="sm"
                            variant="destructive"
                            onClick={() => {
                              setEmployeeDeleteTarget(item);
                              setEmployeeDeleteOpen(true);
                            }}
                          >
                            删除
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="building">
          <div className="grid gap-4 xl:grid-cols-[0.95fr_1.05fr]">
            <Card>
              <CardHeader>
                <CardTitle>楼栋列表</CardTitle>
                <CardDescription>
                  楼栋默认创建在当前管理员组织下，栏舍作为楼栋子节点维护。
                </CardDescription>
                <CardAction className="flex flex-wrap items-center gap-2">
                  <Button size="sm" onClick={() => openBuildingDialog()}>
                    新增楼栋
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={loadBuildingPage}
                  >
                    刷新楼栋
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={loadBuildingTree}
                  >
                    刷新树结构
                  </Button>
                </CardAction>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-3 md:grid-cols-3">
                  <Card size="sm" className="shadow-none">
                    <CardContent className="p-3">
                      <div className="text-xs text-muted-foreground">
                        楼栋总数
                      </div>
                      <div className="mt-1 text-lg font-semibold">
                        {buildingList.length}
                      </div>
                    </CardContent>
                  </Card>
                  <Card size="sm" className="shadow-none">
                    <CardContent className="p-3">
                      <div className="text-xs text-muted-foreground">
                        栏舍总数
                      </div>
                      <div className="mt-1 text-lg font-semibold">
                        {totalPenCount}
                      </div>
                    </CardContent>
                  </Card>
                  <Card size="sm" className="shadow-none">
                    <CardContent className="p-3">
                      <div className="text-xs text-muted-foreground">
                        所属组织
                      </div>
                      <div className="mt-1 text-sm font-semibold">
                        {organizationName}
                      </div>
                    </CardContent>
                  </Card>
                </div>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>ID</TableHead>
                      <TableHead>编码</TableHead>
                      <TableHead>名称</TableHead>
                      <TableHead>组织</TableHead>
                      <TableHead className="text-right">操作</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {buildingList.map((item) => (
                      <TableRow key={item.id}>
                        <TableCell>{item.id}</TableCell>
                        <TableCell>{item.buildingCode}</TableCell>
                        <TableCell>{item.buildingName}</TableCell>
                        <TableCell>
                          {item.orgName || organizationName}
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex justify-end gap-2">
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => openPenDialog(undefined, item.id)}
                            >
                              新增栏舍
                            </Button>
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => openBuildingDialog(item)}
                            >
                              修改
                            </Button>
                            <Button
                              size="sm"
                              variant="destructive"
                              onClick={() => {
                                setBuildingDeleteTarget(item);
                                setBuildingDeleteOpen(true);
                              }}
                            >
                              删除
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>楼栋 - 栏舍树</CardTitle>
                <CardDescription>
                  以树形结构查看楼栋和所属栏舍，详情、修改、删除都从这里进入。
                </CardDescription>
              </CardHeader>
              <CardContent>
                <BuildingTreePanel
                  buildings={buildingTree?.buildings || []}
                  onAddPen={(buildingId) =>
                    openPenDialog(undefined, buildingId)
                  }
                  onEditBuilding={(building) => openBuildingDialog(building)}
                  onDeleteBuilding={(building) => {
                    setBuildingDeleteTarget({
                      id: building.id,
                      buildingCode: building.buildingCode,
                      buildingName: building.buildingName,
                    });
                    setBuildingDeleteOpen(true);
                  }}
                  onViewPen={openPenDetail}
                  onEditPen={(pen) => openPenDialog(pen)}
                  onDeletePen={(pen, buildingName) => {
                    setPenDeleteTarget({ pen, buildingName });
                    setPenDeleteOpen(true);
                  }}
                />
              </CardContent>
            </Card>
          </div>
        </TabsContent>
      </Tabs>

      <Dialog open={employeeDialogOpen} onOpenChange={setEmployeeDialogOpen}>
        <DialogContent className="sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {employeeForm.id ? "修改员工" : "新增员工"}
            </DialogTitle>
            <DialogDescription>
              员工会默认归属 {organizationName}，无需手动选择组织。
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-3 md:grid-cols-2">
            <div className="space-y-1.5">
              <Label>账号</Label>
              <Input
                value={employeeForm.username}
                disabled={Boolean(employeeForm.id)}
                onChange={(event) => {
                  setEmployeeForm((prev) => ({
                    ...prev,
                    username: event.target.value,
                  }));
                  setEmployeeFieldErrors((prev) => ({
                    ...prev,
                    username: undefined,
                  }));
                }}
                aria-invalid={Boolean(employeeFieldErrors.username)}
                placeholder="新增员工必填"
              />
              <FieldError message={employeeFieldErrors.username} />
            </div>
            <div className="space-y-1.5">
              <Label>密码</Label>
              <Input
                type="password"
                value={employeeForm.password}
                onChange={(event) => {
                  setEmployeeForm((prev) => ({
                    ...prev,
                    password: event.target.value,
                  }));
                  setEmployeeFieldErrors((prev) => ({
                    ...prev,
                    password: undefined,
                  }));
                }}
                aria-invalid={Boolean(employeeFieldErrors.password)}
                placeholder={
                  employeeForm.id ? "修改时留空不提交" : "新增员工必填"
                }
              />
              <FieldError message={employeeFieldErrors.password} />
            </div>
            <div className="space-y-1.5">
              <Label>姓名</Label>
              <Input
                value={employeeForm.name}
                onChange={(event) => {
                  setEmployeeForm((prev) => ({
                    ...prev,
                    name: event.target.value,
                  }));
                  setEmployeeFieldErrors((prev) => ({
                    ...prev,
                    name: undefined,
                  }));
                }}
                aria-invalid={Boolean(employeeFieldErrors.name)}
                placeholder="员工姓名"
              />
              <FieldError message={employeeFieldErrors.name} />
            </div>
            <div className="space-y-1.5">
              <Label>性别</Label>
              <Input
                value={employeeForm.sex}
                onChange={(event) => {
                  setEmployeeForm((prev) => ({
                    ...prev,
                    sex: event.target.value,
                  }));
                  setEmployeeFieldErrors((prev) => ({
                    ...prev,
                    sex: undefined,
                  }));
                }}
                aria-invalid={Boolean(employeeFieldErrors.sex)}
                placeholder="男/女"
              />
              <FieldError message={employeeFieldErrors.sex} />
            </div>
            <div className="space-y-1.5">
              <Label>手机号</Label>
              <Input
                value={employeeForm.phone}
                onChange={(event) => {
                  setEmployeeForm((prev) => ({
                    ...prev,
                    phone: event.target.value,
                  }));
                  setEmployeeFieldErrors((prev) => ({
                    ...prev,
                    phone: undefined,
                  }));
                }}
                aria-invalid={Boolean(employeeFieldErrors.phone)}
                placeholder="手机号"
              />
              <FieldError message={employeeFieldErrors.phone} />
            </div>
            <div className="space-y-1.5">
              <Label>头像（可选）</Label>
              <Input
                type="file"
                accept="image/*"
                onChange={(event) =>
                  setEmployeeForm((prev) => ({
                    ...prev,
                    picture: event.target.files?.[0] || null,
                  }))
                }
              />
            </div>
          </div>
          <div className="flex items-center gap-2 rounded-lg border p-3">
            <Switch
              id="employee-admin-switch"
              checked={employeeForm.admin}
              onCheckedChange={(next) =>
                setEmployeeForm((prev) => ({
                  ...prev,
                  admin: Boolean(next),
                }))
              }
            />
            <Label htmlFor="employee-admin-switch">管理员账号</Label>
            <span className="ml-auto text-xs text-muted-foreground">
              当前组织：{organizationName}
            </span>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">取消</Button>
            </DialogClose>
            <Button onClick={submitEmployeeForm}>
              {employeeForm.id ? "保存修改" : "创建员工"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={employeeQueryOpen} onOpenChange={setEmployeeQueryOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>查询员工</DialogTitle>
            <DialogDescription>
              按姓名筛选员工，或直接从当前列表中选择员工打开详情。
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-3">
            <div className="space-y-1.5">
              <Label>姓名</Label>
              <Input
                value={employeeSearchName}
                onChange={(event) => setEmployeeSearchName(event.target.value)}
                placeholder="输入员工姓名"
              />
            </div>
            <div className="space-y-1.5">
              <Label>员工</Label>
              <Select
                value={employeeDetailId}
                onValueChange={setEmployeeDetailId}
              >
                <SelectTrigger>
                  <SelectValue placeholder="从当前员工列表中选择" />
                </SelectTrigger>
                <SelectContent>
                  {employeeList.map((item) => (
                    <SelectItem key={item.id} value={String(item.id)}>
                      {item.name || item.username}（{item.username}）
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setEmployeeSearchName("");
                void loadEmployeePage();
              }}
            >
              重置列表
            </Button>
            <Button variant="outline" onClick={() => void loadEmployeeDetail()}>
              查看详情
            </Button>
            <Button onClick={searchEmployees}>搜索</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={employeeDetailOpen} onOpenChange={setEmployeeDetailOpen}>
        <DialogContent className="sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>员工详情</DialogTitle>
            <DialogDescription>当前组织范围内的员工档案。</DialogDescription>
          </DialogHeader>
          <div className="max-h-[72vh] overflow-y-auto pr-1">
            <EmployeeDetailCard
              employee={employeeDetail}
              organizationName={organizationName}
            />
          </div>
        </DialogContent>
      </Dialog>

      <Dialog
        open={employeeDeleteOpen}
        onOpenChange={(open) => {
          setEmployeeDeleteOpen(open);
          if (!open) {
            setEmployeeDeleteTarget(null);
          }
        }}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>删除员工</DialogTitle>
            <DialogDescription>
              删除后员工将无法继续登录移动端。
            </DialogDescription>
          </DialogHeader>
          <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-4 text-sm text-muted-foreground">
            {employeeDeleteTarget
              ? `即将删除员工「${employeeDeleteTarget.name || employeeDeleteTarget.username}」。删除后该账号将无法继续登录。`
              : "请选择要删除的员工。"}
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button
                variant="outline"
                onClick={() => setEmployeeDeleteTarget(null)}
              >
                取消
              </Button>
            </DialogClose>
            <Button variant="destructive" onClick={deleteEmployee}>
              确认删除
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog
        open={employeeBatchDeleteOpen}
        onOpenChange={setEmployeeBatchDeleteOpen}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>批量删除员工</DialogTitle>
            <DialogDescription>
              请输入当前组织内员工 ID，多个 ID 用英文逗号分隔。
            </DialogDescription>
          </DialogHeader>
          <Input
            value={employeeBatchDeleteIds}
            onChange={(event) => setEmployeeBatchDeleteIds(event.target.value)}
            placeholder="例如：1001,1002"
          />
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">取消</Button>
            </DialogClose>
            <Button variant="destructive" onClick={deleteEmployeeBatch}>
              批量删除
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={buildingDialogOpen} onOpenChange={setBuildingDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {buildingForm.id ? "修改楼栋" : "新增楼栋"}
            </DialogTitle>
            <DialogDescription>
              楼栋会默认归属 {organizationName}。
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-3 md:grid-cols-2">
            <div className="space-y-1.5">
              <Label>楼栋编码</Label>
              <Input
                value={buildingForm.buildingCode}
                onChange={(event) =>
                  setBuildingForm((prev) => ({
                    ...prev,
                    buildingCode: event.target.value,
                  }))
                }
                placeholder="楼栋编码"
              />
            </div>
            <div className="space-y-1.5">
              <Label>楼栋名称</Label>
              <Input
                value={buildingForm.buildingName}
                onChange={(event) =>
                  setBuildingForm((prev) => ({
                    ...prev,
                    buildingName: event.target.value,
                  }))
                }
                placeholder="楼栋名称"
              />
            </div>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">取消</Button>
            </DialogClose>
            <Button onClick={submitBuildingForm}>
              {buildingForm.id ? "保存修改" : "创建楼栋"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog
        open={buildingDeleteOpen}
        onOpenChange={(open) => {
          setBuildingDeleteOpen(open);
          if (!open) {
            setBuildingDeleteTarget(null);
          }
        }}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>删除楼栋</DialogTitle>
            <DialogDescription>
              请确认该楼栋下没有仍在使用的栏舍或任务。
            </DialogDescription>
          </DialogHeader>
          <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-4 text-sm text-muted-foreground">
            {buildingDeleteTarget
              ? `即将删除楼栋「${buildingDeleteTarget.buildingName}」。请确认该楼栋下已无仍在执行的任务和栏舍依赖。`
              : "请选择要删除的楼栋。"}
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button
                variant="outline"
                onClick={() => setBuildingDeleteTarget(null)}
              >
                取消
              </Button>
            </DialogClose>
            <Button variant="destructive" onClick={deleteBuilding}>
              确认删除
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={penDialogOpen} onOpenChange={setPenDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{penForm.id ? "修改栏舍" : "新增栏舍"}</DialogTitle>
            <DialogDescription>
              栏舍必须挂在当前组织的某个楼栋下。
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-3 md:grid-cols-2">
            <div className="space-y-1.5">
              <Label>所属楼栋</Label>
              <Select
                value={penForm.buildingId}
                onValueChange={(value) =>
                  setPenForm((prev) => ({
                    ...prev,
                    buildingId: value,
                  }))
                }
              >
                <SelectTrigger>
                  <SelectValue placeholder="请选择所属楼栋" />
                </SelectTrigger>
                <SelectContent>
                  {buildingList.map((item) => (
                    <SelectItem key={item.id} value={String(item.id)}>
                      {item.buildingName}（{item.buildingCode || `#${item.id}`}
                      ）
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>栏舍编码</Label>
              <Input
                value={penForm.penCode}
                onChange={(event) =>
                  setPenForm((prev) => ({
                    ...prev,
                    penCode: event.target.value,
                  }))
                }
                placeholder="栏舍编码"
              />
            </div>
            <div className="space-y-1.5 md:col-span-2">
              <Label>栏舍名称</Label>
              <Input
                value={penForm.penName}
                onChange={(event) =>
                  setPenForm((prev) => ({
                    ...prev,
                    penName: event.target.value,
                  }))
                }
                placeholder="栏舍名称"
              />
            </div>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">取消</Button>
            </DialogClose>
            <Button onClick={submitPenForm}>
              {penForm.id ? "保存修改" : "创建栏舍"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={penDetailOpen} onOpenChange={setPenDetailOpen}>
        <DialogContent className="sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>栏舍详情</DialogTitle>
            <DialogDescription>
              栏舍挂在楼栋下，通过树形结构维护。
            </DialogDescription>
          </DialogHeader>
          <PenDetailCard
            pen={selectedPen}
            buildingName={selectedPenBuildingName}
          />
        </DialogContent>
      </Dialog>

      <Dialog
        open={penDeleteOpen}
        onOpenChange={(open) => {
          setPenDeleteOpen(open);
          if (!open) {
            setPenDeleteTarget(null);
          }
        }}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>删除栏舍</DialogTitle>
            <DialogDescription>
              请确认该栏舍没有仍在执行或统计的任务。
            </DialogDescription>
          </DialogHeader>
          <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-4 text-sm text-muted-foreground">
            {penDeleteTarget
              ? `即将删除栏舍「${penDeleteTarget.pen.penName}」${penDeleteTarget.buildingName ? `，所属楼栋「${penDeleteTarget.buildingName}」` : ""}。`
              : "请选择要删除的栏舍。"}
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button
                variant="outline"
                onClick={() => setPenDeleteTarget(null)}
              >
                取消
              </Button>
            </DialogClose>
            <Button variant="destructive" onClick={deletePen}>
              确认删除
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
