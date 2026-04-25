export type ApiFieldErrors = Record<string, string | undefined>;

export type AuthTokens = {
  token?: string;
  accessToken?: string;
  refreshToken?: string;
  tokenType?: string;
  expiresIn?: number;
  refreshExpiresIn?: number;
};

export type ApiResult<T> =
  | {
      code: 200;
      message: string | null;
      data: T;
      ok: true;
    }
  | {
      code: number;
      message: string | null;
      data: ApiFieldErrors | null;
      ok: false;
    };

export type PageResult<T> = {
  total: number;
  list: T[];
};

export type LoginUser = AuthTokens & {
  id: number;
  orgId: number;
  username: string;
  name: string;
  profilePicture?: string;
  organization?: string;
  admin: boolean;
};

export type OrgRecord = {
  id: number;
  orgCode: string;
  orgName: string;
  adminName: string;
  tel: string;
  addr: string;
  photoDedupWindowDays: number;
  valid?: boolean;
};

export type EmployeeRecord = {
  id: number;
  username: string;
  name: string;
  sex: string;
  phone: string;
  profilePicture: string;
  organization: string;
  admin: boolean;
  orgId: number;
};

export type BuildingRecord = {
  id: number;
  buildingCode: string;
  buildingName: string;
  orgCode?: string;
  orgName?: string;
};

export type PenRecord = {
  id: number;
  buildingId: number;
  penCode: string;
  penName: string;
};

export type BuildingTree = {
  orgId: number;
  buildings: Array<{
    id: number;
    code: string;
    name: string;
    pens: Array<{
      id: number;
      code: string;
      name: string;
    }>;
  }>;
};

export type TaskSummary = {
  id: number;
  taskName: string;
  employeeId: number;
  startTime: string;
  endTime: string;
  valid: boolean;
  orgId: number;
  taskStatus: string;
  issuedAt: string;
  receivedAt: string;
  completedAt: string;
};

export type TaskDetail = TaskSummary & {
  assignedPenCount: number;
  uploadedPenCount: number;
  confirmedPenCount: number;
  processingPenCount: number;
  failedPenCount: number;
  unboundMediaCount: number;
  buildings: Array<{
    buildingId: number;
    buildingName: string;
    pens: Array<{
      mediaId?: number | null;
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
    }>;
  }>;
};

export type MediaRecord = {
  id: number;
  mediaId?: number;
  taskId: number;
  orgId: number;
  penId: number;
  mediaType: string;
  picturePath: string;
  outputPicturePath: string;
  thumbnailPath: string;
  time: string;
  captureTime: string;
  dayBucket: string;
  count: number;
  manualCount: number;
  processingStatus: string;
  processingMessage: string;
  status: boolean;
  duplicate: boolean;
  analysisJson: string;
};

export type DeadPigReport = {
  reportId: number;
  orgId: number;
  penId: number;
  reportDate: string;
  quantity: number;
  remark: string;
  status: string;
  createdAt: string;
  mediaList: Array<{
    id: number;
    picturePath: string;
    similarityScore: number;
  }>;
};

export type PenMediaSummary = {
  statDate: string;
  sampleSize: number;
  avgCount: number;
  minCount: number;
  maxCount: number;
};

export type PenInventoryStat = {
  sampleSize: number;
  avgCount: number;
  minCount: number;
  maxCount: number;
  finalCount: number;
  deadPigQuantity: number;
};

export type PenInventoryMediaSummary = {
  totalMediaCount: number;
  imageMediaCount: number;
  videoMediaCount: number;
  confirmedMediaCount: number;
  unconfirmedMediaCount: number;
  pendingMediaCount: number;
  processingMediaCount: number;
  successMediaCount: number;
  failedMediaCount: number;
};

export type PenInventoryTrend = PenInventoryStat & {
  statDate: string;
};

export type PenInventoryOverview = {
  orgId: number;
  orgName: string;
  buildingId: number;
  buildingName: string;
  penId: number;
  penCode: string;
  penName: string;
  focusDate: string;
  trendStartDate: string;
  trendEndDate: string;
  todayLiveStat: PenInventoryStat;
  todayConfirmedStat: PenInventoryStat;
  todayMediaSummary: PenInventoryMediaSummary;
  latestMedia: MediaRecord | null;
  recentMedia: MediaRecord[];
  confirmedTrend: PenInventoryTrend[];
};

export type DailyInventoryPenReport = {
  penId: number;
  penName: string;
  sampleSize: number;
  avgCount: number;
  minCount: number;
  maxCount: number;
  finalCount: number;
  deadPigQuantity: number;
};

export type DailyInventoryBuildingReport = {
  buildingId: number;
  buildingName: string;
  pens: DailyInventoryPenReport[];
};

export type DailyInventoryReport = {
  orgId: number;
  orgName: string;
  reportDate: string;
  buildings: DailyInventoryBuildingReport[];
};

export type ComprehensiveInventoryDailySnapshot = {
  statDate: string;
  sampleSize: number;
  avgCount: number;
  finalCount: number;
};

export type ComprehensiveInventoryPenReport = {
  penId: number;
  penName: string;
  includedDays: number;
  avgDailyCount: number;
  recommendedCount: number;
  deadPigQuantity: number;
  dailySnapshots: ComprehensiveInventoryDailySnapshot[];
};

export type ComprehensiveInventoryBuildingReport = {
  buildingId: number;
  buildingName: string;
  pens: ComprehensiveInventoryPenReport[];
};

export type ComprehensiveInventoryReport = {
  orgId: number;
  orgName: string;
  startDate: string;
  endDate: string;
  buildings: ComprehensiveInventoryBuildingReport[];
};

export type PdfExport = {
  objectKey: string;
  accessUrl: string;
  fileName: string;
  generatedAt: string;
  cached: boolean;
};

export type EmployeeUpsertPayload = {
  id?: number;
  username?: string;
  password?: string;
  name: string;
  sex: string;
  phone?: string;
  admin: boolean;
  picture?: File | null;
};

export type TaskCreatePayload = {
  employeeId: number;
  taskName: string;
  startTime: string;
  endTime: string;
  buildings: Array<{
    buildingId: number;
    pens: Array<{ penId: number }>;
  }>;
};
