"use client";

import {
  BarChart3,
  ClipboardList,
  Database,
  ShieldCheck,
  UserRound,
} from "lucide-react";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Separator } from "@/components/ui/separator";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarInset,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar";
import { Badge } from "@/components/ui/badge";
import { APP_CONSTANTS } from "@/constants/app";
import { resolveAssetUrl, type LoginUser } from "@/lib/api";
import type { AdminView } from "@/components/admin/types";

const NAV_ITEMS: Array<{
  key: AdminView;
  title: string;
  subTitle: string;
  icon: React.ComponentType<{ className?: string }>;
}> = [
  {
    key: "master",
    title: "主数据",
    subTitle: "组织、员工、楼栋、栏舍",
    icon: Database,
  },
  {
    key: "task",
    title: "任务管理",
    subTitle: "下发任务、跟进执行",
    icon: ClipboardList,
  },
  {
    key: "review",
    title: "任务复核",
    subTitle: "按任务查看上传、修正并确认",
    icon: ShieldCheck,
  },
  {
    key: "report",
    title: "报表中心",
    subTitle: "看板与日报综合导出",
    icon: BarChart3,
  },
];

export function AdminShell({
  profile,
  activeView,
  onViewChange,
  onLogout,
  children,
}: {
  profile: LoginUser;
  activeView: AdminView;
  onViewChange: (view: AdminView) => void;
  onLogout: () => void;
  children: React.ReactNode;
}) {
  const activeMeta =
    NAV_ITEMS.find((item) => item.key === activeView) ?? NAV_ITEMS[0];
  const userInitial = (profile.name || profile.username || "A")
    .slice(0, 1)
    .toUpperCase();

  return (
    <SidebarProvider defaultOpen>
      <Sidebar variant="inset" collapsible="icon">
        <SidebarHeader>
          <div className="flex items-center gap-2 rounded-lg bg-sidebar-accent/70 p-2 transition-[padding,gap] group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:gap-0">
            <div className="flex size-8 items-center justify-center rounded-md bg-primary text-primary-foreground">
              <Database className="size-4" />
            </div>
            <div className="grid flex-1 text-left text-xs leading-tight group-data-[collapsible=icon]:hidden">
              <span className="truncate font-semibold">
                {APP_CONSTANTS.appName}
              </span>
              <span className="truncate text-muted-foreground">
                {APP_CONSTANTS.adminShortName}
              </span>
            </div>
          </div>
        </SidebarHeader>
        <SidebarContent>
          <SidebarGroup>
            <SidebarGroupLabel>业务导航</SidebarGroupLabel>
            <SidebarMenu>
              {NAV_ITEMS.map((item) => {
                const Icon = item.icon;
                return (
                  <SidebarMenuItem key={item.key}>
                    <SidebarMenuButton
                      isActive={activeView === item.key}
                      tooltip={item.subTitle}
                      onClick={() => onViewChange(item.key)}
                    >
                      <Icon className="size-4" />
                      <span>{item.title}</span>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroup>
        </SidebarContent>
        <SidebarFooter>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button
                variant="outline"
                className="w-full justify-start gap-2 group-data-[collapsible=icon]:size-10 group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:px-2"
              >
                <Avatar className="size-6">
                  <AvatarImage
                    src={resolveAssetUrl(profile.profilePicture)}
                    alt={profile.name}
                  />
                  <AvatarFallback>{userInitial}</AvatarFallback>
                </Avatar>
                <span className="truncate group-data-[collapsible=icon]:hidden">
                  {profile.name || profile.username}
                </span>
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-64">
              <DropdownMenuLabel className="space-y-1">
                <div className="text-sm font-medium">
                  {profile.name || profile.username}
                </div>
                <div className="text-xs text-muted-foreground">
                  {profile.organization || `组织 ${profile.orgId}`}
                </div>
              </DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem className="cursor-default">
                <UserRound className="mr-2 size-4" />
                <span>{profile.admin ? "管理员账号" : "员工账号"}</span>
              </DropdownMenuItem>
              <DropdownMenuItem className="cursor-pointer" onClick={onLogout}>
                退出登录
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </SidebarFooter>
      </Sidebar>
      <SidebarInset>
        <header className="sticky top-0 z-20 flex h-14 items-center gap-2 border-b border-border/60 bg-background/75 px-4 backdrop-blur">
          <SidebarTrigger />
          <Separator orientation="vertical" className="h-4" />
          <Breadcrumb>
            <BreadcrumbList>
              <BreadcrumbItem>{APP_CONSTANTS.adminShortName}</BreadcrumbItem>
              <BreadcrumbSeparator />
              <BreadcrumbItem>
                <BreadcrumbPage>{activeMeta.title}</BreadcrumbPage>
              </BreadcrumbItem>
            </BreadcrumbList>
          </Breadcrumb>
          <div className="ml-auto flex items-center gap-2">
            <Badge variant="secondary">
              {profile.organization || `组织 ${profile.orgId}`}
            </Badge>
            <Badge variant={profile.admin ? "default" : "outline"}>
              {profile.admin ? "管理员" : "员工"}
            </Badge>
          </div>
        </header>
        <div className="flex-1 p-4 md:p-6">
          <div className="mx-auto flex w-full max-w-[1500px] flex-col gap-4">
            {children}
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}
