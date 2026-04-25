"use client";

import { useCallback, useEffect, useMemo, useState } from "react";

import { AdminShell } from "@/components/admin/admin-shell";
import { LoginPanel } from "@/components/admin/login-panel";
import { MasterDataSection } from "@/components/admin/master-data-section";
import { NoticeBanner } from "@/components/admin/notice-banner";
import { ReportSection } from "@/components/admin/report-section";
import { ReviewSection } from "@/components/admin/review-section";
import { TaskSection } from "@/components/admin/task-section";
import type { AdminView, Notice } from "@/components/admin/types";
import { createAdminApi, getApiFieldErrors, type LoginUser } from "@/lib/api";

const SESSION_STORAGE_KEY = "pig_counter_admin_session";
const ACCESS_TOKEN_STORAGE_KEY = "pig_counter_admin_token";
const REFRESH_TOKEN_STORAGE_KEY = "pig_counter_admin_refresh_token";
const ACTIVE_VIEW_STORAGE_KEY = "pig_counter_admin_active_view";

type LoginErrors = {
  username?: string;
  password?: string;
};

function normalizeStoredProfile(raw: LoginUser | null) {
  if (!raw) return null;
  const accessToken = raw.accessToken?.trim() || raw.token?.trim() || "";
  if (!accessToken) {
    return null;
  }
  return {
    ...raw,
    token: accessToken,
    accessToken,
    refreshToken: raw.refreshToken?.trim() || "",
    tokenType: raw.tokenType?.trim() || "Bearer",
  } satisfies LoginUser;
}

function getStoredProfile() {
  const raw = localStorage.getItem(SESSION_STORAGE_KEY);
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw) as LoginUser;
    const legacyAccessToken =
      localStorage.getItem(ACCESS_TOKEN_STORAGE_KEY) || undefined;
    const legacyRefreshToken =
      localStorage.getItem(REFRESH_TOKEN_STORAGE_KEY) || undefined;
    return normalizeStoredProfile({
      ...parsed,
      token: parsed.token || parsed.accessToken || legacyAccessToken,
      accessToken: parsed.accessToken || parsed.token || legacyAccessToken,
      refreshToken: parsed.refreshToken || legacyRefreshToken,
    });
  } catch {
    return null;
  }
}

function persistProfile(profile: LoginUser) {
  localStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(profile));
  localStorage.setItem(
    ACCESS_TOKEN_STORAGE_KEY,
    profile.accessToken || profile.token || "",
  );
  if (profile.refreshToken) {
    localStorage.setItem(REFRESH_TOKEN_STORAGE_KEY, profile.refreshToken);
  } else {
    localStorage.removeItem(REFRESH_TOKEN_STORAGE_KEY);
  }
}

export default function Home() {
  const [notice, setNotice] = useState<Notice | null>(null);
  const [activeView, setActiveView] = useState<AdminView>("master");
  const [sessionReady, setSessionReady] = useState(false);
  const [profile, setProfile] = useState<LoginUser | null>(null);

  const [loginUsername, setLoginUsername] = useState("");
  const [loginPassword, setLoginPassword] = useState("");
  const [loginErrors, setLoginErrors] = useState<LoginErrors>({});
  const [loggingIn, setLoggingIn] = useState(false);

  const notify = useCallback((next: Notice) => setNotice(next), []);
  const dismissNotice = useCallback(() => setNotice(null), []);

  useEffect(() => {
    const frame = window.requestAnimationFrame(() => {
      setProfile(getStoredProfile());
      const storedView = localStorage.getItem(
        ACTIVE_VIEW_STORAGE_KEY,
      ) as AdminView | null;
      if (
        storedView &&
        ["master", "task", "review", "report"].includes(storedView)
      ) {
        setActiveView(storedView);
      }
      setSessionReady(true);
    });
    return () => window.cancelAnimationFrame(frame);
  }, []);

  useEffect(() => {
    if (!sessionReady) return;
    localStorage.setItem(ACTIVE_VIEW_STORAGE_KEY, activeView);
  }, [activeView, sessionReady]);

  useEffect(() => {
    if (!notice) return;
    const timeout = window.setTimeout(
      () => setNotice((current) => (current === notice ? null : current)),
      notice.type === "error" ? 5000 : 3200,
    );
    return () => window.clearTimeout(timeout);
  }, [notice]);

  const clearSession = useCallback(
    (withNotice = true, text = "已退出登录") => {
      setProfile(null);
      localStorage.removeItem(SESSION_STORAGE_KEY);
      localStorage.removeItem(ACCESS_TOKEN_STORAGE_KEY);
      localStorage.removeItem(REFRESH_TOKEN_STORAGE_KEY);
      if (withNotice) {
        notify({ type: "info", text });
      }
    },
    [notify],
  );

  const handleAuthRefresh = useCallback((tokens: Partial<LoginUser>) => {
    setProfile((current) => {
      if (!current) return current;
      const nextProfile = normalizeStoredProfile({
        ...current,
        ...tokens,
      });
      if (!nextProfile) return current;
      persistProfile(nextProfile);
      return nextProfile;
    });
  }, []);

  const api = useMemo(
    () =>
      createAdminApi({
        getAccessToken: () => profile?.accessToken || profile?.token || null,
        getRefreshToken: () => profile?.refreshToken || null,
        getTokenType: () => profile?.tokenType || "Bearer",
        onAuthRefresh: handleAuthRefresh,
        onUnauthorized: () => clearSession(true, "登录已过期，请重新登录"),
      }),
    [clearSession, handleAuthRefresh, profile],
  );

  async function handleLogin() {
    if (loggingIn) return;

    const nextErrors: LoginErrors = {};
    const username = loginUsername.trim();
    const password = loginPassword.trim();

    if (!username) {
      nextErrors.username = "请输入用户名";
    }
    if (!password) {
      nextErrors.password = "请输入密码";
    }

    setLoginErrors(nextErrors);
    if (nextErrors.username || nextErrors.password) {
      notify({ type: "error", text: "请补全登录信息" });
      return;
    }

    setLoggingIn(true);
    try {
      const result = await api.login(username, password);
      if (!result.ok) {
        const fieldErrors = getApiFieldErrors(result);
        if (fieldErrors) {
          setLoginErrors({
            username: fieldErrors.username,
            password: fieldErrors.password,
          });
        }
        notify({ type: "error", text: result.message || "登录失败" });
        return;
      }
      setLoginErrors({});
      const nextProfile = normalizeStoredProfile(result.data);
      if (!nextProfile) {
        notify({ type: "error", text: "登录成功，但令牌返回格式不完整" });
        return;
      }
      setProfile(nextProfile);
      persistProfile(nextProfile);
      notify({ type: "success", text: "登录成功" });
    } catch (error) {
      notify({
        type: "error",
        text: error instanceof Error ? error.message : "登录失败，请稍后重试",
      });
    } finally {
      setLoggingIn(false);
    }
  }

  if (!sessionReady) {
    return (
      <main className="flex min-h-screen items-center justify-center bg-[radial-gradient(circle_at_12%_16%,rgba(20,184,166,0.18),transparent_30%),radial-gradient(circle_at_86%_12%,rgba(14,116,144,0.16),transparent_32%),linear-gradient(180deg,#f8fcfb_0%,#eef6f4_100%)] px-4">
        <div className="rounded-2xl border bg-card px-5 py-4 text-sm text-muted-foreground shadow-xs">
          正在恢复管理端会话...
        </div>
      </main>
    );
  }

  if (!profile) {
    return (
      <>
        <FloatingNotice notice={notice} onDismiss={dismissNotice} />
        <LoginPanel
          username={loginUsername}
          password={loginPassword}
          loading={loggingIn}
          notice={null}
          usernameError={loginErrors.username}
          passwordError={loginErrors.password}
          onUsernameChange={(value) => {
            setLoginUsername(value);
            if (loginErrors.username) {
              setLoginErrors((current) => ({
                ...current,
                username: undefined,
              }));
            }
          }}
          onPasswordChange={(value) => {
            setLoginPassword(value);
            if (loginErrors.password) {
              setLoginErrors((current) => ({
                ...current,
                password: undefined,
              }));
            }
          }}
          onSubmit={handleLogin}
        />
      </>
    );
  }

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_10%_20%,rgba(65,153,145,0.16),transparent_35%),radial-gradient(circle_at_90%_10%,rgba(58,123,213,0.16),transparent_35%),linear-gradient(180deg,#f7fbfd_0%,#eff4f7_100%)]">
      <FloatingNotice notice={notice} onDismiss={dismissNotice} />
      <AdminShell
        profile={profile}
        activeView={activeView}
        onViewChange={setActiveView}
        onLogout={() => clearSession()}
      >
        {activeView === "master" ? (
          <MasterDataSection api={api} profile={profile} notify={notify} />
        ) : null}
        {activeView === "task" ? (
          <TaskSection api={api} notify={notify} />
        ) : null}
        {activeView === "review" ? (
          <ReviewSection api={api} notify={notify} />
        ) : null}
        {activeView === "report" ? (
          <ReportSection api={api} notify={notify} />
        ) : null}
      </AdminShell>
    </div>
  );
}

function FloatingNotice({
  notice,
  onDismiss,
}: {
  notice: Notice | null;
  onDismiss: () => void;
}) {
  if (!notice) return null;

  return (
    <div className="pointer-events-none fixed inset-x-0 top-4 z-[80] flex justify-center px-4 sm:justify-end">
      <NoticeBanner
        notice={notice}
        onDismiss={onDismiss}
        className="pointer-events-auto w-full max-w-md shadow-lg backdrop-blur"
      />
    </div>
  );
}
