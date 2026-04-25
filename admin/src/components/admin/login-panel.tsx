"use client";

import {
  ArrowRight,
  ClipboardCheck,
  KeyRound,
  ShieldCheck,
  UserRound,
} from "lucide-react";

import { NoticeBanner } from "@/components/admin/notice-banner";
import type { Notice } from "@/components/admin/types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { APP_CONSTANTS } from "@/constants/app";
import { cn } from "@/lib/utils";

function FieldError({ id, message }: { id: string; message?: string }) {
  return (
    <p
      id={id}
      aria-live="polite"
      className="min-h-4 text-xs leading-4 text-destructive"
    >
      {message ?? ""}
    </p>
  );
}

export function LoginPanel({
  username,
  password,
  loading,
  notice,
  usernameError,
  passwordError,
  onUsernameChange,
  onPasswordChange,
  onSubmit,
}: {
  username: string;
  password: string;
  loading: boolean;
  notice: Notice | null;
  usernameError?: string;
  passwordError?: string;
  onUsernameChange: (value: string) => void;
  onPasswordChange: (value: string) => void;
  onSubmit: () => void;
}) {
  const hasUsernameError = Boolean(usernameError);
  const hasPasswordError = Boolean(passwordError);

  return (
    <main className="relative min-h-screen overflow-hidden bg-[radial-gradient(circle_at_12%_16%,rgba(20,184,166,0.18),transparent_30%),radial-gradient(circle_at_86%_12%,rgba(14,116,144,0.16),transparent_32%),linear-gradient(180deg,#f8fcfb_0%,#eef6f4_100%)] px-4 py-8 sm:px-6">
      <div className="pointer-events-none absolute inset-x-0 top-0 h-36 bg-[linear-gradient(90deg,rgba(15,118,110,0.14),rgba(2,132,199,0.08),rgba(15,23,42,0.04))]" />
      <div className="pointer-events-none absolute -left-24 top-1/3 size-64 rounded-full bg-teal-200/30 blur-3xl" />
      <div className="pointer-events-none absolute -right-20 bottom-10 size-72 rounded-full bg-cyan-200/30 blur-3xl" />

      <div className="relative mx-auto flex min-h-[calc(100vh-4rem)] w-full max-w-5xl items-center justify-center">
        <div className="grid w-full overflow-hidden rounded-[2rem] border border-white/70 bg-white/80 shadow-[0_30px_90px_rgba(15,23,42,0.16)] backdrop-blur-xl lg:grid-cols-[0.92fr_1.08fr]">
          <section className="relative hidden min-h-[560px] flex-col justify-between overflow-hidden bg-primary p-8 text-primary-foreground lg:flex">
            <div className="absolute -right-16 top-10 size-48 rounded-full bg-primary-foreground/10 blur-2xl" />
            <div className="absolute -bottom-20 left-10 size-56 rounded-full bg-primary-foreground/10 blur-3xl" />

            <div className="relative space-y-6">
              <Badge className="border border-primary-foreground/20 bg-primary-foreground/10 text-primary-foreground shadow-none backdrop-blur">
                <ShieldCheck className="size-3" />
                {APP_CONSTANTS.loginBadge}
              </Badge>
              <div className="space-y-3">
                <h1 className="text-3xl font-semibold leading-tight tracking-tight">
                  {APP_CONSTANTS.appName}
                  <span className="block text-primary-foreground/70">
                    让猪场数据流转更清楚
                  </span>
                </h1>
                <p className="max-w-sm text-sm leading-6 text-primary-foreground/70">
                  管理基础资料、下发巡栏盘点任务、复核员工上报结果，并沉淀每日库存与异常记录。
                </p>
              </div>
            </div>

            <div className="relative grid gap-3 text-sm">
              <div className="rounded-2xl border border-primary-foreground/15 bg-primary-foreground/10 p-4 backdrop-blur">
                <div className="flex items-center gap-2 font-medium">
                  <ClipboardCheck className="size-4 text-primary-foreground/80" />
                  今日流程
                </div>
                <p className="mt-2 text-primary-foreground/70">
                  创建任务、员工移动端执行、后台复核、报表归档。
                </p>
              </div>
              <div className="grid grid-cols-3 gap-2 text-center">
                {["圈舍", "任务", "复核"].map((item) => (
                  <div
                    key={item}
                    className="rounded-2xl border border-primary-foreground/15 bg-primary-foreground/10 px-3 py-3 text-primary-foreground/80"
                  >
                    {item}
                  </div>
                ))}
              </div>
            </div>
          </section>

          <Card className="justify-center rounded-none bg-white/90 py-8 ring-0 sm:py-10">
            <CardHeader className="space-y-3 px-6 pb-2 sm:px-10">
              <div className="flex size-12 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                <ShieldCheck className="size-6" />
              </div>
              <div className="space-y-1.5">
                <CardTitle className="text-2xl font-semibold tracking-tight">
                  欢迎回来
                </CardTitle>
                <CardDescription>
                  请输入管理员账号后进入{APP_CONSTANTS.adminName}。
                </CardDescription>
              </div>
            </CardHeader>

            <CardContent className="px-6 sm:px-10">
              <form
                className="space-y-4"
                noValidate
                onSubmit={(event) => {
                  event.preventDefault();
                  onSubmit();
                }}
              >
                <NoticeBanner notice={notice} className="mb-1" />

                <div className="space-y-2">
                  <Label
                    htmlFor="login-username"
                    className={cn(hasUsernameError && "text-destructive")}
                  >
                    用户名
                  </Label>
                  <div className="relative">
                    <UserRound className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
                    <Input
                      id="login-username"
                      value={username}
                      onChange={(event) => onUsernameChange(event.target.value)}
                      placeholder="请输入用户名"
                      autoComplete="username"
                      autoFocus
                      disabled={loading}
                      aria-invalid={hasUsernameError}
                      aria-describedby="login-username-error"
                      className="h-11 bg-background/70 pl-9"
                    />
                  </div>
                  <FieldError
                    id="login-username-error"
                    message={usernameError}
                  />
                </div>

                <div className="space-y-2">
                  <Label
                    htmlFor="login-password"
                    className={cn(hasPasswordError && "text-destructive")}
                  >
                    密码
                  </Label>
                  <div className="relative">
                    <KeyRound className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
                    <Input
                      id="login-password"
                      type="password"
                      value={password}
                      onChange={(event) => onPasswordChange(event.target.value)}
                      placeholder="请输入密码"
                      autoComplete="current-password"
                      disabled={loading}
                      aria-invalid={hasPasswordError}
                      aria-describedby="login-password-error"
                      className="h-11 bg-background/70 pl-9"
                    />
                  </div>
                  <FieldError
                    id="login-password-error"
                    message={passwordError}
                  />
                </div>

                <Button
                  className="h-11 w-full gap-2"
                  disabled={loading}
                  type="submit"
                >
                  {loading ? "登录中..." : "进入工作台"}
                  {!loading ? <ArrowRight className="size-4" /> : null}
                </Button>

                <p className="text-center text-xs leading-5 text-muted-foreground">
                  登录后会保持本机管理会话，401 过期会自动回到此页面。
                </p>
              </form>
            </CardContent>
          </Card>
        </div>
      </div>
    </main>
  );
}
