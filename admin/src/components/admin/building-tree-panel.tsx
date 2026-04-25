"use client";

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
import type { BuildingTree, PenRecord } from "@/lib/api";

type TreeBuilding = BuildingTree["buildings"][number];
type TreePen = TreeBuilding["pens"][number];

export function BuildingTreePanel({
  buildings,
  onAddPen,
  onEditBuilding,
  onDeleteBuilding,
  onViewPen,
  onEditPen,
  onDeletePen,
}: {
  buildings: TreeBuilding[];
  onAddPen: (buildingId: number) => void;
  onEditBuilding: (building: {
    id: number;
    buildingCode: string;
    buildingName: string;
  }) => void;
  onDeleteBuilding: (building: {
    id: number;
    buildingCode: string;
    buildingName: string;
  }) => void;
  onViewPen: (pen: PenRecord, buildingName?: string) => void;
  onEditPen: (pen: PenRecord) => void;
  onDeletePen: (pen: PenRecord, buildingName?: string) => void;
}) {
  if (!buildings.length) {
    return (
      <div className="rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
        当前组织还没有楼栋和栏舍，先创建楼栋后再补充栏舍。
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {buildings.map((building) => (
        <Card key={building.id} className="border-border/70 shadow-none">
          <CardHeader className="border-b border-border/60">
            <div className="space-y-1">
              <CardTitle className="flex flex-wrap items-center gap-2">
                <span>{building.name || `楼栋 #${building.id}`}</span>
                <Badge variant="secondary">#{building.id}</Badge>
                <Badge variant="outline">{building.code || "未设置编码"}</Badge>
              </CardTitle>
              <CardDescription>
                共 {building.pens.length} 个栏舍，栏舍作为楼栋子节点维护。
              </CardDescription>
            </div>
            <CardAction className="flex flex-wrap gap-2">
              <Button size="sm" onClick={() => onAddPen(building.id)}>
                新增栏舍
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() =>
                  onEditBuilding({
                    id: building.id,
                    buildingCode: building.code,
                    buildingName: building.name,
                  })
                }
              >
                修改楼栋
              </Button>
              <Button
                size="sm"
                variant="destructive"
                onClick={() =>
                  onDeleteBuilding({
                    id: building.id,
                    buildingCode: building.code,
                    buildingName: building.name,
                  })
                }
              >
                删除楼栋
              </Button>
            </CardAction>
          </CardHeader>
          <CardContent className="pt-4">
            {building.pens.length ? (
              <div className="relative ml-1 space-y-3 border-l border-border/70 pl-5">
                {building.pens.map((pen) => (
                  <TreePenCard
                    key={pen.id}
                    building={building}
                    pen={pen}
                    onViewPen={onViewPen}
                    onEditPen={onEditPen}
                    onDeletePen={onDeletePen}
                  />
                ))}
              </div>
            ) : (
              <div className="rounded-xl border border-dashed p-4 text-sm text-muted-foreground">
                该楼栋下还没有栏舍，可以直接从右上角新增。
              </div>
            )}
          </CardContent>
        </Card>
      ))}
    </div>
  );
}

function TreePenCard({
  building,
  pen,
  onViewPen,
  onEditPen,
  onDeletePen,
}: {
  building: TreeBuilding;
  pen: TreePen;
  onViewPen: (pen: PenRecord, buildingName?: string) => void;
  onEditPen: (pen: PenRecord) => void;
  onDeletePen: (pen: PenRecord, buildingName?: string) => void;
}) {
  const mappedPen: PenRecord = {
    id: pen.id,
    buildingId: building.id,
    penCode: pen.code,
    penName: pen.name,
  };

  return (
    <div className="relative rounded-xl border border-border/70 bg-muted/20 p-3">
      <span className="absolute -left-[1.45rem] top-5 size-2 rounded-full bg-primary" />
      <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
        <div className="min-w-0 space-y-1">
          <div className="flex flex-wrap items-center gap-2">
            <div className="font-medium">{pen.name || `栏舍 #${pen.id}`}</div>
            <Badge variant="secondary">#{pen.id}</Badge>
            <Badge variant="outline">{pen.code || "未设置编码"}</Badge>
          </div>
          <div className="text-xs text-muted-foreground">
            归属楼栋：{building.name || building.id}
          </div>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button
            size="sm"
            variant="ghost"
            onClick={() => onViewPen(mappedPen, building.name)}
          >
            详情
          </Button>
          <Button
            size="sm"
            variant="outline"
            onClick={() => onEditPen(mappedPen)}
          >
            修改
          </Button>
          <Button
            size="sm"
            variant="destructive"
            onClick={() => onDeletePen(mappedPen, building.name)}
          >
            删除
          </Button>
        </div>
      </div>
    </div>
  );
}
