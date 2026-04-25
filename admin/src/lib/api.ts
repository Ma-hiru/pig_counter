import type {
  AuthTokens,
  ApiResult,
  ApiFieldErrors,
  BuildingRecord,
  BuildingTree,
  ComprehensiveInventoryReport,
  DailyInventoryReport,
  DeadPigReport,
  EmployeeRecord,
  EmployeeUpsertPayload,
  LoginUser,
  MediaRecord,
  OrgRecord,
  PageResult,
  PdfExport,
  PenInventoryOverview,
  PenMediaSummary,
  PenRecord,
  TaskCreatePayload,
  TaskDetail,
  TaskSummary,
} from "@/lib/models";

export type {
  AuthTokens,
  ApiResult,
  ApiFieldErrors,
  BuildingRecord,
  BuildingTree,
  ComprehensiveInventoryReport,
  DailyInventoryReport,
  DeadPigReport,
  EmployeeRecord,
  EmployeeUpsertPayload,
  LoginUser,
  MediaRecord,
  OrgRecord,
  PageResult,
  PdfExport,
  PenInventoryOverview,
  PenMediaSummary,
  PenRecord,
  TaskCreatePayload,
  TaskDetail,
  TaskSummary,
} from "@/lib/models";

type QueryValue = string | number | boolean | undefined | null;

type RequestOptions = {
  query?: Record<string, QueryValue>;
  body?: unknown;
  useAuth?: boolean;
  isFormData?: boolean;
};

const API_PREFIX = "/api";
const API_BASE_URL = (
  process.env.NEXT_PUBLIC_API_BASE_URL || "http://8.148.152.24"
).replace(/\/$/, "");

export function resolveAssetUrl(path?: string | null) {
  const value = path?.trim();
  if (!value) return "";
  if (/^https?:\/\//.test(value)) return value;
  if (value.startsWith("/")) {
    return `${API_BASE_URL}${value}`;
  }
  return `${API_BASE_URL}/${value}`;
}

function buildQueryString(query?: Record<string, QueryValue>) {
  if (!query) return "";
  const searchParams = new URLSearchParams();
  Object.entries(query).forEach(([key, value]) => {
    if (value === null || value === undefined || value === "") return;
    searchParams.set(key, String(value));
  });
  const q = searchParams.toString();
  return q ? `?${q}` : "";
}

function normalizePath(path: string) {
  if (/^https?:\/\//.test(path)) return path;
  return `${API_BASE_URL}${path.startsWith(API_PREFIX) ? path : `${API_PREFIX}${path}`}`;
}

function assertApiResult<T>(value: unknown): asserts value is ApiResult<T> {
  if (!value || typeof value !== "object") {
    throw new Error("后端返回格式错误");
  }
  const maybe = value as Partial<ApiResult<T>>;
  if (typeof maybe.ok !== "boolean" || typeof maybe.code !== "number") {
    throw new Error("后端返回格式错误");
  }
}

export function getApiErrorMessage(value: unknown) {
  if (!value || typeof value !== "object") {
    return "网络异常，请稍后重试";
  }
  const maybe = value as Partial<ApiResult<unknown>>;
  if (typeof maybe.message === "string" && maybe.message.trim()) {
    return maybe.message;
  }
  return "操作失败";
}

export function getApiFieldErrors(value: unknown): ApiFieldErrors | null {
  if (!value || typeof value !== "object") return null;
  const data = (value as Partial<ApiResult<unknown>>).data;
  if (!data || typeof data !== "object" || Array.isArray(data)) return null;
  const entries = Object.entries(data).filter(
    ([, message]) => message !== null && message !== undefined,
  );
  if (!entries.length) return null;
  return Object.fromEntries(
    entries.map(([field, message]) => [field, String(message)]),
  );
}

function buildEmployeeFormData(payload: EmployeeUpsertPayload) {
  const formData = new FormData();
  Object.entries(payload).forEach(([key, raw]) => {
    if (raw === null || raw === undefined || key === "picture") return;
    formData.append(key, String(raw));
  });
  if (payload.picture) {
    formData.append("picture", payload.picture);
  }
  return formData;
}

function normalizeAuthTokens(raw: AuthTokens | null | undefined): AuthTokens {
  const accessToken = raw?.accessToken?.trim() || raw?.token?.trim() || "";
  const refreshToken = raw?.refreshToken?.trim() || "";
  const tokenType = raw?.tokenType?.trim() || "Bearer";
  return {
    ...raw,
    token: accessToken || raw?.token || "",
    accessToken,
    refreshToken,
    tokenType,
  };
}

function buildAuthorizationValue(token: string, tokenType?: string | null) {
  const normalizedToken = token.trim();
  if (!normalizedToken) return null;
  if (/^[A-Za-z]+\s+/.test(normalizedToken)) {
    return normalizedToken;
  }
  const normalizedType = tokenType?.trim() || "Bearer";
  return normalizedType
    ? `${normalizedType} ${normalizedToken}`
    : normalizedToken;
}

export function createAdminApi({
  getAccessToken,
  getRefreshToken,
  getTokenType,
  onAuthRefresh,
  onUnauthorized,
}: {
  getAccessToken: () => string | null;
  getRefreshToken: () => string | null;
  getTokenType?: () => string | null;
  onAuthRefresh?: (tokens: AuthTokens) => void;
  onUnauthorized?: () => void;
}) {
  let refreshingPromise: Promise<AuthTokens | null> | null = null;

  async function parsePayload<T>(response: Response) {
    try {
      const payload = (await response.json()) as unknown;
      assertApiResult<T>(payload);
      return payload;
    } catch {
      return null;
    }
  }

  async function refreshAccessToken() {
    if (refreshingPromise) {
      return refreshingPromise;
    }

    const refreshToken = getRefreshToken()?.trim();
    if (!refreshToken) {
      return null;
    }

    refreshingPromise = (async () => {
      try {
        const response = await fetch(normalizePath("/user/refresh"), {
          method: "POST",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ refreshToken }),
        });
        const payload = await parsePayload<AuthTokens>(response);
        if (!payload?.ok) {
          onUnauthorized?.();
          return null;
        }
        const nextTokens = normalizeAuthTokens(payload.data);
        if (!nextTokens.accessToken) {
          onUnauthorized?.();
          return null;
        }
        onAuthRefresh?.(nextTokens);
        return nextTokens;
      } catch {
        onUnauthorized?.();
        return null;
      } finally {
        refreshingPromise = null;
      }
    })();

    return refreshingPromise;
  }

  async function request<T>(
    method: string,
    path: string,
    options: RequestOptions = {},
    allowRetry = true,
  ) {
    const url = `${normalizePath(path)}${buildQueryString(options.query)}`;
    const headers = new Headers();
    headers.set("Accept", "application/json");
    if (options.useAuth !== false) {
      const token = getAccessToken();
      const authorizationValue = token
        ? buildAuthorizationValue(token, getTokenType?.())
        : null;
      if (authorizationValue) {
        headers.set("Authorization", authorizationValue);
      }
    }
    if (!options.isFormData) {
      headers.set("Content-Type", "application/json");
    }

    const response = await fetch(url, {
      method,
      headers,
      body:
        options.body === undefined
          ? undefined
          : options.isFormData
            ? (options.body as BodyInit)
            : JSON.stringify(options.body),
    });
    const payload = await parsePayload<T>(response);
    const isUnauthorized =
      response.status === 401 || Boolean(payload && payload.code === 401);
    const isRefreshRequest = path === "/user/refresh";
    const isLoginRequest = path === "/user/login";

    if (
      isUnauthorized &&
      options.useAuth !== false &&
      allowRetry &&
      !isRefreshRequest &&
      !isLoginRequest
    ) {
      const refreshed = await refreshAccessToken();
      if (refreshed?.accessToken) {
        return request<T>(method, path, options, false);
      }
      throw new Error(payload?.message || "登录已过期，请重新登录");
    }

    if (!payload) {
      if (!response.ok) {
        throw new Error(`请求失败（${response.status}）`);
      }
      throw new Error("后端返回格式错误");
    }

    if (payload.code === 401 && !isRefreshRequest) {
      onUnauthorized?.();
      throw new Error(payload.message || "登录已过期，请重新登录");
    }
    return payload;
  }

  return {
    login: (username: string, password: string) =>
      request<LoginUser>("POST", "/user/login", {
        useAuth: false,
        body: { username, password },
      }),
    refresh: (refreshToken: string) =>
      request<AuthTokens>("POST", "/user/refresh", {
        useAuth: false,
        body: { refreshToken },
      }),
    logout: () => request<null>("POST", "/user/logout", { body: {} }),

    getOrgPage: (pageNum = 1, pageSize = 10) =>
      request<PageResult<OrgRecord>>("GET", "/org/page", {
        query: { pageNum, pageSize },
      }),
    addOrg: (payload: Omit<OrgRecord, "id">) =>
      request<null>("POST", "/org/add", { body: payload }),
    updateOrg: (payload: OrgRecord) =>
      request<null>("PUT", "/org", { body: payload }),
    deleteOrg: (id: number) => request<null>("DELETE", `/org/${id}`),

    getUserPage: (pageNum = 1, pageSize = 10) =>
      request<PageResult<EmployeeRecord>>("GET", "/user/page", {
        query: { pageNum, pageSize },
      }),
    getUserDetail: (id: number) =>
      request<EmployeeRecord>("GET", `/user/${id}`),
    searchUsers: (payload: Partial<EmployeeRecord>) =>
      request<PageResult<EmployeeRecord>>("POST", "/user/search", {
        body: payload,
      }),
    registerUser: (payload: EmployeeUpsertPayload) =>
      request<null>("POST", "/user/register", {
        isFormData: true,
        body: buildEmployeeFormData(payload),
      }),
    updateUser: (payload: EmployeeUpsertPayload) =>
      request<null>("PUT", "/user", {
        isFormData: true,
        body: buildEmployeeFormData(payload),
      }),
    deleteUser: (id: number) => request<null>("DELETE", `/user/${id}`),
    deleteUsers: (ids: number[]) =>
      request<null>("DELETE", "/user/batch", { body: ids }),

    getBuildingCurrent: () => request<BuildingTree>("GET", "/building/current"),
    getBuildingPage: (pageNum = 1, pageSize = 10) =>
      request<PageResult<BuildingRecord>>("GET", "/building/page", {
        query: { pageNum, pageSize },
      }),
    addBuilding: (payload: { buildingCode: string; buildingName: string }) =>
      request<null>("POST", "/building/add", { body: payload }),
    updateBuilding: (payload: {
      id: number;
      buildingCode: string;
      buildingName: string;
    }) => request<null>("PUT", "/building", { body: payload }),
    deleteBuilding: (id: number) => request<null>("DELETE", `/building/${id}`),

    getPenPage: (buildingId: number, pageNum = 1, pageSize = 10) =>
      request<PageResult<PenRecord>>("GET", "/pen/page", {
        query: { buildingId, pageNum, pageSize },
      }),
    addPen: (payload: {
      buildingId: number;
      penCode: string;
      penName: string;
    }) => request<null>("POST", "/pen/add", { body: payload }),
    updatePen: (payload: {
      id: number;
      buildingId: number;
      penCode: string;
      penName: string;
    }) => request<null>("PUT", "/pen", { body: payload }),
    deletePen: (id: number) => request<null>("DELETE", `/pen/${id}`),

    getTaskPage: (pageNum = 1, pageSize = 10) =>
      request<PageResult<TaskSummary>>("GET", "/task/page", {
        query: { pageNum, pageSize },
      }),
    addTask: (payload: TaskCreatePayload) =>
      request<null>("POST", "/task/add", { body: payload }),
    getTaskDetail: (taskId: number) =>
      request<TaskDetail>("GET", `/task/detail/${taskId}`),
    deleteTask: (taskId: number) => request<null>("DELETE", `/task/${taskId}`),

    getMediaLibrary: (penId: number, date: string) =>
      request<MediaRecord[]>("GET", "/inventory/media/library", {
        query: { penId, date },
      }),
    confirmMedia: (mediaIds: number[], status = true) =>
      request<null>("POST", "/inventory/media/confirm", {
        body: { mediaIds, status },
      }),
    unlockMedia: (mediaIds: number[], status = true) =>
      request<null>("POST", "/inventory/media/unlock", {
        body: { mediaIds, status },
      }),
    manualCount: (mediaId: number, manualCount: number) =>
      request<null>("POST", "/inventory/media/manual-count", {
        body: { mediaId, manualCount },
      }),
    deleteMedia: (mediaId: number) =>
      request<null>("DELETE", `/inventory/media/${mediaId}`),

    getDeadPigDaily: (penId: number, date: string) =>
      request<DeadPigReport[]>("GET", "/inventory/dead-pig/daily", {
        query: { penId, date },
      }),
    getMediaSummary: (penId: number, startDate: string, endDate: string) =>
      request<PageResult<PenMediaSummary>>("GET", "/inventory/media/summary", {
        query: { penId, startDate, endDate },
      }),

    getPenOverview: (query: {
      penId: number;
      date?: string;
      startDate?: string;
      endDate?: string;
      recentMediaLimit?: number;
    }) => request<PenInventoryOverview>("GET", "/pen/overview", { query }),
    getDailyReport: (date: string) =>
      request<DailyInventoryReport>("GET", "/inventory/report/daily", {
        query: { date },
      }),
    getDailyReportPdf: (date: string, regenerate = false) =>
      request<PdfExport>("GET", "/inventory/report/daily/pdf", {
        query: { date, regenerate },
      }),
    getComprehensiveReport: (startDate: string, endDate: string) =>
      request<ComprehensiveInventoryReport>(
        "GET",
        "/inventory/report/comprehensive",
        {
          query: { startDate, endDate },
        },
      ),
    getComprehensiveReportPdf: (
      startDate: string,
      endDate: string,
      regenerate = false,
    ) =>
      request<PdfExport>("GET", "/inventory/report/comprehensive/pdf", {
        query: { startDate, endDate, regenerate },
      }),
  };
}

export type AdminApi = ReturnType<typeof createAdminApi>;
