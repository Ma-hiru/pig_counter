# 前端联调手册

## 1. 基本约定

- 接口前缀统一为 `/api`
- 登录后把 `token` 放到请求头 `Authorization`
- 当前 token 的 claims 中已带 `empId` 和 `orgId`
- 组织级接口默认按 token 中的 `orgId` 处理，不需要前端重复传 `orgId`
- `POST /building/add` 和 `PUT /building` 不再接收 `orgId`
- `POST /pen/add` 和 `PUT /pen` 只需要传 `buildingId`、`penCode`、`penName`
- `POST /org/add` 和 `PUT /org` 不需要传 `source`、`enabled`、`erpId`
- 所有盘点媒体接口统一走 `/inventory/media/*`
- 通用返回结构如下：

```json
{
  "code": 200,
  "message": null,
  "data": {},
  "ok": true
}
```

## 2. 角色一：组织管理员

## 2.1 管理员要做什么

- 维护本组织主数据：组织信息、员工、楼栋、栏舍
- 下发盘点任务给员工
- 查看任务执行情况
- 复核媒体、确认盘点结果、必要时人工纠偏
- 查看日报、综合报告并导出 PDF

## 2.2 管理员主流程

1. 登录
2. 维护组织、员工、楼栋、栏舍
3. 创建盘点任务并分配给员工
4. 跟进员工任务执行情况
5. 审核媒体并确认结果
6. 查看日报、综合报告、栏舍看板并导出 PDF

## 2.3 管理员要用的接口

| 场景 | 接口 | 干什么 | 为什么这样用 |
| --- | --- | --- | --- |
| 登录 | `POST /user/login` | 登录后台管理端 | 登录后返回 `token`、`id`、`orgId`、`admin`，后续接口都依赖这些信息 |
| 组织列表 | `GET /org/page` | 查看组织列表 | 如果前端有组织管理页，用这条展示组织数据 |
| 新增组织 | `POST /org/add` | 新建组织 | 当前接口存在，前端如有组织管理功能可以直接对接 |
| 修改组织 | `PUT /org` | 修改组织信息 | 用来维护组织名称、负责人、电话、地址、去重窗口 |
| 删除组织 | `DELETE /org/{id}` | 停用组织 | 后端实际是逻辑停用，不会物理删除历史数据 |
| 新增员工 | `POST /user/register` | 创建员工或管理员账号 | 员工登录、任务分配都依赖员工数据 |
| 修改员工 | `PUT /user` | 修改员工信息 | 用于改姓名、管理员标识、头像等 |
| 员工分页 | `GET /user/page` | 员工管理页列表 | 组织管理员一般先查员工，再分配任务 |
| 员工详情 | `GET /user/{id}` | 查看单个员工 | 员工编辑页回显 |
| 删除员工 | `DELETE /user/{id}` | 删除单个员工 | 管理员维护人员时使用 |
| 批量删员工 | `DELETE /user/batch` | 批量删除员工 | 管理后台批量操作时用 |
| 员工搜索 | `POST /user/search` | 按条件筛员工 | 后台筛选人员时可直接用 |
| 楼栋树 | `GET /building/current` | 获取当前组织的楼栋-栏舍树 | 创建任务、级联选择器、主数据树结构都优先用这条，不需要前端自己拼 |
| 楼栋分页 | `GET /building/page` | 楼栋管理列表 | 楼栋表格页使用 |
| 新增楼栋 | `POST /building/add` | 新增楼栋 | 楼栋归属由后端从 token 取，不让前端传 `orgId` |
| 修改楼栋 | `PUT /building` | 修改楼栋 | 同样不传 `orgId`，避免前端把楼栋改到别的组织 |
| 删除楼栋 | `DELETE /building/{id}` | 停用楼栋 | 后端会级联停用该楼栋下栏舍 |
| 栏舍分页 | `GET /pen/page` | 查询某楼栋下的栏舍 | 栏舍列表页按楼栋维度展示时用 |
| 新增栏舍 | `POST /pen/add` | 新增栏舍 | 栏舍必须挂在楼栋下，所以要传 `buildingId` |
| 修改栏舍 | `PUT /pen` | 修改栏舍 | 如果要调整到新楼栋，后端会校验目标楼栋仍属于当前组织 |
| 删除栏舍 | `DELETE /pen/{id}` | 停用栏舍 | 后端保留历史盘点数据 |
| 任务分页 | `GET /task/page` | 查询本组织任务列表 | 管理员任务管理页入口 |
| 创建任务 | `POST /task/add` | 下发任务给员工 | 任务归属组织由后端从 token 取，前端重点传员工、时间、楼栋栏舍范围 |
| 任务详情 | `GET /task/detail/{taskId}` | 看任务执行情况 | 一次返回进度、楼栋栏舍、媒体状态，避免前端多接口拼装 |
| 栏舍媒体库 | `GET /inventory/media/library` | 看某栏舍当天媒体 | 审核图片、视频、处理状态都靠它 |
| 确认媒体 | `POST /inventory/media/confirm` | 确认媒体有效 | 只有确认后的媒体才会进入正式日报和 PDF |
| 解锁媒体 | `POST /inventory/media/unlock` | 允许重新纠错 | 已确认媒体默认不能删，必须先解锁 |
| 人工改数 | `POST /inventory/media/manual-count` | 修正 AI 数量 | AI 数量异常时管理员可以人工兜底 |
| 删除媒体 | `DELETE /inventory/media/{mediaId}` | 删除错误媒体 | 一般只对未确认或已解锁媒体使用 |
| 栏舍看板 | `GET /pen/overview` | 看单个栏舍详情 | 已经聚合了实时统计、正式统计、趋势、最近媒体，不建议前端自己拼 |
| 栏舍区间汇总 | `GET /inventory/media/summary` | 查某栏舍区间媒体汇总 | 做栏舍维度统计页时可选用 |
| 日报 | `GET /inventory/report/daily` | 看某天盘点日报 | 管理员日常查看当天正式结果 |
| 日报 PDF | `GET /inventory/report/daily/pdf` | 导出日报 PDF | 默认复用缓存，必要时再强制重生成 |
| 综合报告 | `GET /inventory/report/comprehensive` | 看区间综合报告 | 适合月度、阶段性汇总 |
| 综合 PDF | `GET /inventory/report/comprehensive/pdf` | 导出综合 PDF | 同样支持缓存复用 |
| 死猪日报 | `GET /inventory/dead-pig/daily` | 查某栏舍当天死猪上报 | 管理员审核死猪上报时使用 |

## 2.4 管理员接口示例

### 2.4.1 登录

接口：

- `POST /user/login`

干什么：

- 登录后台
- 获取 `token`
- 获取当前管理员 `id`、`orgId`

为什么这样做：

- 之后的任务分页、楼栋树、报表接口都默认按 token 中的组织处理

请求示例：

```json
{
  "username": "backend_admin",
  "password": "Pig12345"
}
```

### 2.4.2 组织维护

接口：

- `GET /org/page?pageNum=1&pageSize=10`
- `POST /org/add`
- `PUT /org`
- `DELETE /org/{id}`

干什么：

- 组织管理页展示和维护组织信息

为什么这样做：

- 组织级配置例如图片去重窗口属于组织本身，不属于楼栋和栏舍

新增请求示例：

```json
{
  "orgCode": "PIG-001",
  "orgName": "示例猪场",
  "adminName": "张三",
  "tel": "13800000000",
  "addr": "广东省广州市",
  "photoDedupWindowDays": 7
}
```

修改请求示例：

```json
{
  "id": 9001,
  "orgCode": "PIG-001",
  "orgName": "示例猪场-更新",
  "adminName": "李四",
  "tel": "13900000000",
  "addr": "广东省深圳市",
  "photoDedupWindowDays": 10
}
```

### 2.4.3 员工维护

接口：

- `GET /user/page?pageNum=1&pageSize=10`
- `GET /user/{id}`
- `POST /user/register`
- `PUT /user`
- `POST /user/search`
- `DELETE /user/{id}`
- `DELETE /user/batch`

干什么：

- 创建员工账号
- 创建管理员账号
- 编辑员工资料和头像

为什么这样做：

- 任务必须先分配给具体员工，员工登录、接收、执行任务都依赖员工资料

新增员工请求示例：

```http
POST /api/user/register
Authorization: <ADMIN_TOKEN>
Content-Type: multipart/form-data
```

表单字段示例：

- `username=worker_a`
- `password=Pig12345`
- `name=员工A`
- `sex=男`
- `phone=13800138000`
- `organization=后端联调测试猪场`
- `admin=false`
- `picture=@avatar.jpg`

修改员工请求示例：

```http
PUT /api/user
Authorization: <ADMIN_TOKEN>
Content-Type: multipart/form-data
```

表单字段示例：

- `id=9302`
- `name=员工A-更新`
- `sex=男`
- `phone=13800138001`
- `orgId=9001`
- `admin=false`
- `picture=@avatar-new.jpg`

### 2.4.4 楼栋和栏舍维护

接口：

- `GET /building/current`
- `GET /building/page?pageNum=1&pageSize=10`
- `POST /building/add`
- `PUT /building`
- `DELETE /building/{id}`
- `GET /pen/page?pageNum=1&pageSize=10&buildingId=9101`
- `POST /pen/add`
- `PUT /pen`
- `DELETE /pen/{id}`

干什么：

- 楼栋页和栏舍页维护主数据
- 创建任务时给前端提供楼栋-栏舍树

为什么这样做：

- `GET /building/current` 已经把当前组织的楼栋和栏舍树一次返回，创建任务时优先用这条
- 楼栋新增和修改不再需要前端传 `orgId`，避免越权和脏数据

新增楼栋请求示例：

```json
{
  "buildingCode": "A",
  "buildingName": "育肥A栋"
}
```

修改楼栋请求示例：

```json
{
  "id": 9101,
  "buildingCode": "A",
  "buildingName": "育肥A栋-更新"
}
```

新增栏舍请求示例：

```json
{
  "buildingId": 9101,
  "penCode": "A-01",
  "penName": "A-01栏"
}
```

修改栏舍请求示例：

```json
{
  "id": 9201,
  "buildingId": 9101,
  "penCode": "A-01",
  "penName": "A-01栏-更新"
}
```

### 2.4.5 创建和查看任务

接口：

- `GET /task/page?pageNum=1&pageSize=10`
- `POST /task/add`
- `GET /task/detail/{taskId}`

干什么：

- 创建任务
- 查看任务执行进度

为什么这样做：

- 任务是员工执行盘点的入口，管理员必须先下发，员工才能接收和上传
- 任务详情已经包含楼栋、栏舍、媒体状态和进度字段，任务详情页直接用

创建任务请求示例：

```json
{
  "employeeId": 9302,
  "taskName": "4月盘点任务",
  "startTime": "2026-04-21 08:00:00",
  "endTime": "2026-04-21 18:00:00",
  "buildings": [
    {
      "buildingId": 9101,
      "pens": [
        { "penId": 9201 },
        { "penId": 9202 }
      ]
    }
  ]
}
```

### 2.4.6 复核媒体和纠偏

接口：

- `GET /task/detail/{taskId}`
- `GET /inventory/media/library?penId={penId}&date={yyyy-MM-dd}`
- `POST /inventory/media/confirm`
- `POST /inventory/media/unlock`
- `POST /inventory/media/manual-count`
- `DELETE /inventory/media/{mediaId}`
- `GET /inventory/dead-pig/daily?penId={penId}&date={yyyy-MM-dd}`

干什么：

- 查某栏舍当天的图片和视频
- 确认是否纳入正式结果
- 对 AI 数量做人工修正
- 删除错误媒体
- 查死猪上报

为什么这样做：

- 正式日报和 PDF 只统计已确认媒体
- 删除和纠错必须在媒体级别完成，不能直接改报表

确认媒体请求示例：

```json
{
  "mediaIds": [9601, 9602]
}
```

人工改数请求示例：

```json
{
  "mediaId": 9601,
  "manualCount": 37
}
```

### 2.4.7 查看看板和报表

接口：

- `GET /pen/overview?penId={penId}&date={yyyy-MM-dd}&startDate={yyyy-MM-dd}&endDate={yyyy-MM-dd}&recentMediaLimit=5`
- `GET /inventory/media/summary?penId={penId}&startDate={yyyy-MM-dd}&endDate={yyyy-MM-dd}`
- `GET /inventory/report/daily?date={yyyy-MM-dd}`
- `GET /inventory/report/daily/pdf?date={yyyy-MM-dd}&regenerate=false`
- `GET /inventory/report/comprehensive?startDate={yyyy-MM-dd}&endDate={yyyy-MM-dd}`
- `GET /inventory/report/comprehensive/pdf?startDate={yyyy-MM-dd}&endDate={yyyy-MM-dd}&regenerate=false`

干什么：

- 栏舍详情页
- 栏舍区间统计页
- 每日盘点报表
- 综合报告
- PDF 导出

为什么这样做：

- 栏舍详情页优先用 `/pen/overview`，不要让前端自己拼日报、媒体库、死猪日报
- PDF 导出支持缓存复用，普通“导出”按钮默认传 `regenerate=false` 就够了

日报请求示例：

```http
GET /api/inventory/report/daily?date=2026-04-21
Authorization: <ADMIN_TOKEN>
```

日报 PDF 请求示例：

```http
GET /api/inventory/report/daily/pdf?date=2026-04-21&regenerate=false
Authorization: <ADMIN_TOKEN>
```

综合 PDF 强制重生成示例：

```http
GET /api/inventory/report/comprehensive/pdf?startDate=2026-04-19&endDate=2026-04-21&regenerate=true
Authorization: <ADMIN_TOKEN>
```

## 3. 角色二：员工

## 3.1 员工要做什么

- 登录
- 查看分配给自己的任务
- 接收任务
- 按任务和栏舍上传图片或视频
- 如有需要先上传未绑定媒体，再补绑栏舍
- 上报死猪
- 完成任务

## 3.2 员工主流程

1. 登录
2. 查询自己的任务列表
3. 接收任务
4. 查看任务详情
5. 按栏舍上传图片或视频
6. 必要时处理未绑定媒体
7. 上报死猪
8. 再看任务详情确认都处理完成
9. 提交完成任务

## 3.3 员工要用的接口

| 场景 | 接口 | 干什么 | 为什么这样用 |
| --- | --- | --- | --- |
| 登录 | `POST /user/login` | 登录员工端 | 登录后拿到 `token`、`id`、`orgId` |
| 任务列表 | `GET /task/{employeeId}` | 查自己的任务 | 当前接口仍要求传员工ID，前端直接用登录返回的 `data.id` |
| 接收任务 | `POST /task/receive/{taskId}` | 把任务从 `PENDING` 变成 `IN_PROGRESS` | 未接收任务前不允许上传 |
| 任务详情 | `GET /task/detail/{taskId}` | 看任务范围和进度 | 一次拿到楼栋、栏舍、媒体处理状态 |
| 已绑定上传 | `POST /inventory/media/upload` | 已经选中栏舍时直接上传 | 适合现场边看栏舍边拍照或录像 |
| 未绑定上传 | `POST /inventory/media/upload/unbound` | 先上传，后面再选栏舍 | 适合网络差或现场不方便立即绑定栏舍 |
| 未绑定列表 | `GET /inventory/media/unbound?taskId={taskId}` | 查未绑定媒体 | 让员工后续补绑 |
| 绑定栏舍 | `PUT /inventory/media/bind` | 把未绑定媒体挂到栏舍 | 一个媒体只有绑定到栏舍后，后续统计才有意义 |
| 栏舍媒体库 | `GET /inventory/media/library` | 看某栏舍当天上传结果 | 图片、视频、AI 状态都在这里看 |
| 栏舍看板 | `GET /pen/overview` | 看单个栏舍数据 | 员工现场查看盘点趋势时可直接用 |
| 死猪上报 | `POST /inventory/dead-pig` | 上传死猪照片和数量 | 独立于普通盘点媒体，单独闭环 |
| 死猪日报 | `GET /inventory/dead-pig/daily` | 查当天死猪记录 | 上报后回查或页面回显 |
| 完成任务 | `POST /task/complete/{taskId}` | 告知后台任务已执行完 | 必须等未绑定媒体处理完、异常媒体处理完再提交 |
| 退出登录 | `POST /user/logout` | 退出当前账号 | 员工端退出登录时使用 |

## 3.4 员工接口示例

### 3.4.1 登录

接口：

- `POST /user/login`

请求示例：

```json
{
  "username": "backend_worker",
  "password": "Pig12345"
}
```

前端要保存：

- `data.id`
- `data.orgId`
- `data.token`
- `data.admin`

### 3.4.2 查询任务列表并接收任务

接口：

- `GET /task/{employeeId}`
- `POST /task/receive/{taskId}`

为什么这样做：

- 当前后端仍以路径参数区分查询哪个员工的任务，所以要把登录返回的 `data.id` 带上
- 接收任务后，后端才允许上传媒体

请求示例：

```http
GET /api/task/9302
Authorization: <EMPLOYEE_TOKEN>
```

```http
POST /api/task/receive/9401
Authorization: <EMPLOYEE_TOKEN>
```

### 3.4.3 查询任务详情

接口：

- `GET /task/detail/{taskId}`

干什么：

- 展示当前任务包含哪些楼栋和栏舍
- 看哪些栏舍已经上传
- 看视频是否还在处理中

为什么这样做：

- 这条接口已经是员工任务页的核心聚合接口，前端不用再拆成多个接口自己拼

请求示例：

```http
GET /api/task/detail/9401
Authorization: <EMPLOYEE_TOKEN>
```

### 3.4.4 上传已绑定栏舍媒体

接口：

- `POST /inventory/media/upload`

干什么：

- 当前页面已经选中栏舍时，直接上传图片或视频

为什么这样做：

- 这条接口最符合“按栏舍盘点”的主流程，上传后结果直接落到该栏舍

请求示例：

```http
POST /api/inventory/media/upload
Authorization: <EMPLOYEE_TOKEN>
Content-Type: multipart/form-data
```

表单字段示例：

- `taskId=9401`
- `penId=9201`
- `captureTime=2026-04-21 09:30:00`
- `files=@A01-1.jpg`
- `files=@A01-2.mp4`

前端重点关注：

- `createdItems[].processingStatus`
- `createdItems[].outputPicturePath`
- `createdItems[].thumbnailPath`
- `duplicateItems`

### 3.4.5 上传未绑定栏舍媒体并补绑

接口：

- `POST /inventory/media/upload/unbound`
- `GET /inventory/media/unbound?taskId={taskId}`
- `PUT /inventory/media/bind`

干什么：

- 先上传媒体
- 后面再把媒体绑定到栏舍

为什么这样做：

- 现场网络差、拍摄节奏快时，不一定每次都能先选栏舍
- 这是为了兼容真实采集场景，不是重复设计

未绑定上传请求示例：

```http
POST /api/inventory/media/upload/unbound
Authorization: <EMPLOYEE_TOKEN>
Content-Type: multipart/form-data
```

表单字段示例：

- `taskId=9401`
- `captureTime=2026-04-21 10:00:00`
- `files=@tmp-1.jpg`
- `files=@tmp-2.mp4`

绑定请求示例：

```json
{
  "penId": 9202,
  "mediaIds": [9606, 9607]
}
```

### 3.4.6 查询栏舍媒体库和栏舍看板

接口：

- `GET /inventory/media/library?penId={penId}&date={yyyy-MM-dd}`
- `GET /pen/overview?penId={penId}&date={yyyy-MM-dd}&startDate={yyyy-MM-dd}&endDate={yyyy-MM-dd}&recentMediaLimit=5`

干什么：

- 看某栏舍当天上传了什么媒体
- 看视频有没有处理完
- 看当前栏舍的实时数量和趋势

为什么这样做：

- 媒体库负责看原始媒体和 AI 结果
- 栏舍看板负责看汇总统计，两条职责不同

媒体库请求示例：

```http
GET /api/inventory/media/library?penId=9201&date=2026-04-21
Authorization: <EMPLOYEE_TOKEN>
```

栏舍看板请求示例：

```http
GET /api/pen/overview?penId=9201&date=2026-04-21&startDate=2026-04-15&endDate=2026-04-21&recentMediaLimit=5
Authorization: <EMPLOYEE_TOKEN>
```

### 3.4.7 死猪上报

接口：

- `POST /inventory/dead-pig`
- `GET /inventory/dead-pig/daily?penId={penId}&date={yyyy-MM-dd}`

干什么：

- 员工上报死猪数量和证据图片
- 查看当天该栏舍已上报记录

为什么这样做：

- 死猪上报和普通盘点图片不是一回事，单独走一套接口，避免混算

请求示例：

```http
POST /api/inventory/dead-pig
Authorization: <EMPLOYEE_TOKEN>
Content-Type: multipart/form-data
```

表单字段示例：

- `penId=9201`
- `reportDate=2026-04-21`
- `captureTime=2026-04-21 15:30:00`
- `quantity=2`
- `remark=发现两头死猪`
- `files=@dead-1.jpg`
- `files=@dead-2.jpg`

### 3.4.8 完成任务

接口：

- `POST /task/complete/{taskId}`

干什么：

- 员工确认该任务下所有栏舍都已经采集完成

为什么这样做：

- 任务完成是整个员工执行闭环的结束标记，后端会拦截未处理完的视频、未绑定媒体和异常状态

请求示例：

```http
POST /api/task/complete/9401
Authorization: <EMPLOYEE_TOKEN>
```

## 4. 为什么有两种媒体上传接口

- `POST /inventory/media/upload` 适合主流程：员工先选栏舍，再拍照或录像，上传后立即挂到该栏舍。
- `POST /inventory/media/upload/unbound` 适合补充流程：员工先采集，后面再慢慢绑定栏舍。
- 这不是重复接口，而是分别覆盖“现场标准流程”和“现场网络差、节奏快”的两种真实场景。
- 前端如果页面已经明确定位到某个栏舍，优先使用 `/inventory/media/upload`。
- 只有在用户确实还没确定栏舍，或者需要先离线/快速采集时，再使用 `/inventory/media/upload/unbound`。

## 5. 前端对接建议

- 管理员端创建任务时，楼栋和栏舍选择器优先用 `GET /building/current`
- 员工任务详情页优先用 `GET /task/detail/{taskId}`，不要自己拼任务进度
- 栏舍详情页优先用 `GET /pen/overview`
- 图片和视频上传后，不要只看上传是否成功，还要看 `processingStatus`
- 视频播放页优先展示 `thumbnailPath` 做封面，处理完成后再播放 `outputPicturePath`
- 日报和 PDF 只认已确认媒体，所以管理员复核页一定要接 `POST /inventory/media/confirm`
- 普通导出 PDF 按钮默认传 `regenerate=false`
- 只有用户明确要求“重新生成最新 PDF”时，前端才传 `regenerate=true`
