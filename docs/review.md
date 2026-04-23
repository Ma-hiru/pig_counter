# 牧豕云鉴（pig_counter）腾讯面试复习稿

## 0. 文档说明

- 目标：把项目架构、核心功能、面试问答、追问答法一次性梳理清楚，便于口述复习。
- 依据：本文基于当前仓库代码整理，不是按理想方案空谈。
- 口径建议：回答时坚持“场景 -> 方案 -> 原因 -> 效果 -> 不足与下一步”这条线。

说明：代码里应用名常量是“智牧云瞳”（lib/constants/app.dart），你简历写“牧豕云鉴”。面试时建议提前说明“这是同一项目的不同命名阶段/代号”，避免面试官误解为两个项目。

---

## 1. 项目一句话（30 秒口述版）

这是一个基于 Flutter 的猪只计数移动端应用，我独立负责了从登录注册、任务列表、媒体采集上传、结果确认到统计展示和设置管理的完整闭环。技术上我做了三件事：

1. 用 GetX + shared_preferences 实现了轻量全局状态和持久化。
2. 用 Dio 封装统一网络层，通过拦截器处理 token 注入、错误归一化。
3. 在媒体链路上接入 image_picker、video_player、photo_view，并结合 path_provider 做本地暂存和缓存治理，保证上传前的预览体验和性能。

---

## 2. 项目架构总览（结合代码）

## 2.1 分层结构

- lib/main.dart：应用启动、平台初始化、全局 store 初始化。
- lib/routes：路由注册与根组件。
- lib/pages：页面层（登录、注册、首页、上传、历史、统计、设置）。
- lib/widgets：可复用组件（任务卡片、统计模块、媒体预览、按钮表单等）。
- lib/stores：GetX 状态中心（用户态、设置态）。
- lib/api + lib/utils/fetch.dart：接口定义与统一请求层。
- lib/models：数据模型（用户、任务、路由参数、设置等）。
- lib/utils/local.dart + persistence.dart + cache.dart：本地存储、对象持久化、媒体缓存。
- lib/constants：颜色、字体、路由、UI 尺寸、错误文案等统一常量。

## 2.2 启动链路

1. main() 调用 init()。
2. init() 里先 WidgetsFlutterBinding.ensureInitialized()。
3. Windows/Linux 平台初始化 video_player_media_kit（跨平台视频播放兼容）。
4. 初始化 SharedPreferences（LocalStore.init）。
5. 初始化 GetX 全局控制器（UserController、SettingsController，permanent: true）。
6. runApp(MaterialApp 根组件)。

这条链路的价值：把平台依赖、状态容器、持久化提前初始化，避免页面层到处做 null 判断。

## 2.3 路由与页面组织

路由为 MaterialApp 的命名路由：

- /：HomePage
- /login：LoginPage
- /signup：SignupPage
- /settings：SettingsPage
- /upload：UploadPage
- /history：HistoryPage
- /stats：StatsPage

首页是三 tab 的 IndexedStack：任务、统计、我的，保证 tab 切换不重复销毁页面状态。

## 2.4 状态管理与持久化设计

### 用户状态（UserController）

- 维护 isLoggedIn、profile 两个核心响应式状态。
- updateUserProfile() 内部统一处理：
  - token 写入/删除。
  - 登录态同步。
  - 用户信息落盘（Persistence.Save）。
- 支持记住账号密码（memoUserAndPwd / clearUserAndPwd）。

### 设置状态（SettingsController）

- upload：图片上传质量等。
- cache：缓存上限配置。
- 设置变更后立即持久化，缓存配置还会触发一次 limitCacheSize。

### 持久化机制

- LocalStore：SharedPreferences 的统一薄封装。
- Persistence：对实现 Persistable 接口的模型做通用 JSON 序列化/反序列化。

设计理由：

- 保留 GetX 的轻量，不引入重框架。
- 通过可序列化模型把“运行态”和“落盘态”统一，减少样板代码。

## 2.5 网络层设计（Dio 封装）

核心在 lib/utils/fetch.dart：

- 统一 baseUrl、连接超时、发送超时。
- onRequest：自动注入 Authorization。
- onResponse/onError：统一错误消息提取，避免页面层重复解析。
- _handleResponse + ResponseData.fromJsonWithType：统一响应格式和泛型数据转换。

配套：

- tokenManager 负责 token 拼接 Bearer 前缀和本地存取。
- API 按模块拆分（AuthAPI、TaskAPI）。

收益：

- 页面只关心业务数据，不关心 headers、状态码和错误文案处理细节。
- 后续扩展重试、日志、埋点更容易。

## 2.6 业务核心流程

### 流程 A：登录/注册

- 登录：表单校验 -> 请求登录接口 -> 更新 user store -> 跳转首页。
- 注册：填写账号、密码、姓名、组织、头像（image_picker）-> multipart/form-data 提交。

### 流程 B：任务 -> 栏位 -> 上传

- 任务卡片可展开到栋舍、栏位。
- 点击栏位进入 UploadPage，携带 task/building/pen 路由参数。
- UploadPage 会优先检查本地暂存缓存（TaskCache.checkOne），有缓存则恢复。
- 上传动作按状态机展示按钮：选择媒体、上传、暂存、取消、确认等。

### 流程 C：媒体预览与交互

- 图片：ImagePreview，支持点击全屏、PhotoView 缩放、旋转。
- 视频：VideoPreview，支持播放/暂停、拖动进度、全屏、旋转。
- 本地与远程媒体源自动分流（File / Network）。

### 流程 D：统计展示

- 统计视图包含：
  - 概览卡片（栋舍数、栏位数、完成数、AI 识别、人工确认）。
  - 各栋进度条。
  - 栏位明细表。
- 历史页可进入单任务详细统计页。

### 流程 E：设置与缓存治理

- 可调整图片质量。
- 可配置最大缓存空间。
- 支持一键清缓存。
- 缓存策略按最近访问时间做淘汰（近似 LRU 思路）。

## 2.7 UI 规范化实践

- 颜色、字体、尺寸、间距常量化（constants/color.dart、font.dart、ui.dart）。
- 统一 toast、modal、dialog 交互组件。
- 组件层复用任务卡片、统计模块、设置菜单，避免页面重复拼 UI。

---

## 3. 简历 6 个技术点与代码落地对照

### 1) 跨平台快速构建

- Flutter + Material 完成多页面业务闭环。
- Linux/Windows 单独初始化 video_player_media_kit，处理跨平台播放差异。

### 2) 轻量状态管理与持久化

- GetX 管用户态和设置态。
- shared_preferences + 通用 Persistence 处理对象落盘。

### 3) 网络层统一封装

- Dio 请求层统一处理鉴权、错误、响应类型转换。

### 4) 媒体处理与本地缓存

- image_picker 采集图片/视频。
- video_player + photo_view 支持预览体验。
- path_provider 管临时缓存目录，TaskCache 管理缓存生命周期。

### 5) 数据展示能力

- 任务列表、历史列表、统计概览、栋舍进度、栏位明细已打通展示链路。

### 6) UI 规范化设计

- 主题色、字体、间距、组件都已抽离为统一规范。

---

## 4. 当前版本边界（面试建议主动说，显得真实）

以下属于“工程推进中的中间态”，建议主动交代：

1. 登录按钮当前绑定的是 testSubmit（测试路径），真实 submit 已写好但未绑定按钮。
2. TaskAPI 的 detail/pen/building 仍是占位返回（ResponseData.success(empty)）。
3. 任务/统计/历史页面当前主要用 Task.test 假数据渲染。
4. Validator.username/password 目前返回 null，校验规则未补全。
5. HTTP baseUrl 仍是示例域名。
6. 上传动作里多处“todo use api”，说明上传与确认流程接口还在对接中。

你可以这样表述：

“我先把前端交互和状态流完全跑通，再分阶段把接口接入点替换进去。当前仓库是可演示闭环和可联调结构，接口联调在收尾阶段。”

---

## 5. 腾讯风格模拟面试问答（主问 + 追问 + 口述回答）

## Q1：你先整体介绍一下这个项目。

- 追问：你在里面负责到什么程度？
- 追问：最体现你工程能力的点是什么？

参考口述：

这是一个猪只计数的 Flutter 应用，我独立实现了从用户登录、任务查看、栏位媒体上传、结果确认到统计展示的全链路。工程上我重点做了三层：第一是 GetX 状态层，解决登录态和设置态全局共享；第二是 Dio 网络层封装，把 token 注入、错误归一化集中处理；第三是媒体链路，支持图片和视频采集、预览、全屏交互，并加了本地暂存缓存来保证用户在弱网或者中断后不会丢数据。项目目前已经能完整演示业务闭环，接口联调和规则细化在持续推进。

## Q2：为什么用 Flutter + GetX，而不是原生或者更重的状态方案？

- 追问：GetX 会不会太“轻”导致后期失控？

参考口述：

我这个项目是个人主导，目标是快速做出跨平台可运行版本，Flutter 的开发效率和跨端一致性更高。状态管理我选 GetX 是因为业务状态不复杂，主要是用户态、设置态和页面局部状态，GetX 的心智负担小、代码量少。为了避免后期失控，我把状态边界收得很清楚：全局只有 user/settings 两个 store，页面内短期状态仍用 StatefulWidget 管理，不把所有变量都塞进全局响应式。

## Q3：登录态是怎么保证一致性的？

- 追问：应用重启后如何恢复？
- 追问：退出登录会清什么？

参考口述：

登录成功后我统一走 updateUserProfile，这个方法会同时更新 profile、isLoggedIn、tokenManager，并且写入本地持久化。应用重启时，UserController 会从持久化里恢复 profile，再推导出登录态。退出登录同样走同一个入口，清 token、改状态、改持久化，避免出现只改内存不改磁盘的状态分叉。

## Q4：你讲讲 Dio 的封装细节。

- 追问：为什么不用每个接口单独 try-catch？
- 追问：401 怎么处理？

参考口述：

我把公共能力放在 fetch 里：baseUrl 和 timeout 在初始化阶段设好，请求拦截器统一注入 Bearer token，响应和异常拦截器统一抽 message。这样页面层只处理业务成功/失败，不关心底层状态码和解析逻辑。401 的处理点已经在拦截器预留，当前做法是清 token，下一步会补“跳登录页 + 保留原始路由意图”的体验。

## Q5：你为什么做了一层 ResponseData 泛型模型？

- 追问：直接用 Map 不行吗？

参考口述：

可以直接用 Map，但后续维护成本会很高。ResponseData 的价值是把后端统一响应格式固化成强约束，再通过 fromJsonWithType 做二次类型转换。这样每个 API 方法返回值都是明确类型，比如 UserProfile，不是 dynamic。好处是页面代码可读性高、重构安全性高，接口字段变化也更容易定位。

## Q6：媒体上传这一块你怎么设计的？

- 追问：为什么要“暂存”？
- 追问：图片和视频怎么统一处理？

参考口述：

我把栏位上传状态抽象成几个字段：localPath/localType 表示本地待上传素材，uploadPath 表示已上传原始素材，outputPath 表示推理结果，status 表示最终完成。UI 按状态机展示不同按钮，比如未选择时显示“图片/视频”，选择后显示“上传/暂存/取消”，有结果后显示“确认”。

暂存的意义是现场场景里网络不稳定，或者用户中途返回，素材不能丢，所以我把素材复制到应用临时目录，回来可以恢复。

## Q7：本地缓存怎么做？为什么这样做？

- 追问：如何避免缓存无限增长？
- 追问：你淘汰策略是什么？

参考口述：

缓存目录是 path_provider 的 temporaryDirectory 下 media_cache。文件名里编码 taskID、penID、媒体类型，便于按任务栏位回查。保存时直接 copy 文件，恢复时按命名规则扫描。容量控制上有两层：设置页可配置上限，写入配置后立即触发 limitSize，按最后访问时间排序删除，近似 LRU，能兼顾“最近操作任务优先保留”。

## Q8：视频预览里你处理过什么跨平台问题？

- 追问：全屏切换为什么要做“先卸载再 push”？

参考口述：

我在 Linux/Windows 初始化了 video_player_media_kit，避免桌面端解码兼容性问题。视频全屏切换时我做了一个细节：先把内联播放器卸载，再进全屏路由，并在切回后再挂载，目的是减少 texture 切换导致的黑屏和首帧异常；同时会保存播放位置和播放状态，回切时恢复体验。

## Q9：统计页面的数据展示你怎么组织？

- 追问：为什么拆成多个组件？

参考口述：

统计页分四块：任务选择器、概览卡片、各栋进度、栏位明细。我拆组件是为了复用和演进，比如概览和栋舍进度在首页统计页和详情页都能复用，未来接真实接口后只替换数据来源，不重写 UI。数据聚合都挂在 Task/Building 模型的 getter 上，组件不直接写复杂统计逻辑。

## Q10：你做了哪些 UI 规范化工作？

- 追问：这种抽离真的有收益吗？

参考口述：

我把颜色、字体、字号、间距、圆角全部抽成常量，并统一了按钮、输入框、toast、弹窗组件。收益很直接：视觉一致性提升，改主题成本低，页面开发时不需要反复调“魔法数字”，新页面搭建速度会快很多。

## Q11：异常处理是怎么落地的？

- 追问：用户能感知到哪些错误？

参考口述：

异常处理分三层：

1. 网络层统一转成用户可读 message。
2. 业务层区分格式错误和网络错误。
3. UI 层统一用 Toast 给反馈。

媒体采集失败、接口失败、解析失败都能给出明确提示，避免“点了没反应”。

## Q12：你觉得这个项目最有挑战的地方是什么？

- 追问：你具体怎么解决的？

参考口述：

挑战是“媒体交互 + 业务状态一致性”这两个点叠在一起。比如用户可能反复选素材、暂存、取消、重进页面，如果状态设计不好很容易乱。我通过字段状态机把每个阶段定义清楚，再把缓存键和任务栏位绑定，保证恢复路径可预测；另外视频全屏切换做了状态保存，减少了切换时的体验问题。

## Q13：如果让你继续迭代两周，你会优先做什么？

- 追问：为什么不是先做 UI？

参考口述：

我会先做三件工程价值最高的事：

1. 把 Task 相关接口全部联调，替换当前测试数据。
2. 完成表单校验和 401 自动跳登录闭环，提升稳定性。
3. 补基础测试：模型解析单测、缓存策略单测、关键页面流程测试。

因为这三件事会直接影响可上线质量，优先级高于视觉微调。

## Q14：你如何回答“这个项目是不是还没做完”？

- 追问：那你写到简历里会不会太早？

参考口述：

我会坦诚回答：项目已经完成了完整的产品流程和工程骨架，核心页面与交互是可运行可演示的，当前主要在做接口联调替换和规则完善。这类项目在真实团队里也是分阶段推进，我在简历里强调的是我对架构、状态、网络和媒体模块的端到端实现能力。

## Q15：如果面试官追问安全性，比如 token 存储呢？

- 追问：shared_preferences 是否足够安全？

参考口述：

当前实现是 shared_preferences，主要满足开发阶段效率。严格来说，生产环境更推荐 flutter_secure_storage 或平台密钥链方案。我的思路是先保证功能闭环，再在安全层做替换，代码层面只要替换 tokenManager 的存储实现，对上层影响很小。

---

## 6. 可直接背诵的 2 分钟项目介绍

我做的是一个基于 Flutter 的猪只计数应用，定位是把现场采集、上传识别、人工核验和统计分析串成完整闭环。技术栈上我用了 Flutter Material、Dio、GetX、image_picker、video_player、photo_view 和 shared_preferences。

架构上我分了四层：页面组件层、状态层、网络层、持久化与缓存层。状态层用 GetX 管用户态和设置态，结合 shared_preferences 做持久化，保证重启后能恢复登录态和业务配置。网络层我用 Dio 做统一封装，通过拦截器做 token 注入、错误归一化和响应解析，页面层只关心业务结果。媒体能力上我支持图片和视频采集、预览、全屏交互，并通过 path_provider 做本地暂存缓存，弱网场景下用户离开页面也能恢复素材。

业务流程上，用户登录后进入任务页，可下钻到栋舍和栏位，进入上传页完成图片/视频上传和结果确认，统计页可以看任务概览、各栋进度和栏位明细，设置页可以配置图片质量和缓存上限。整体上我做的是一个可联调、可扩展的端侧工程骨架，目前接口联调和规则细化在持续推进。

---

## 7. 面试前速记清单（高频数字）

1. 网络超时：15 秒。
2. 图片上传默认质量：80。
3. 头像上传质量：50。
4. 视频采集最大时长：1 分钟。
5. 默认最大缓存：1 GB。
6. 首页结构：IndexedStack 三 tab（任务/统计/我的）。
7. 缓存命名：taskID_penID_type。

---

## 8. 你可以主动说的“工程化加分项”

1. 我把业务状态抽成字段状态机，而不是把状态散落在 UI if-else。
2. 我把响应解析和错误处理下沉到网络层，避免页面重复逻辑。
3. 我把模型做成可序列化对象，统一运行态和持久化态。
4. 我考虑了跨平台视频播放差异，桌面端单独初始化媒体内核。
5. 我给缓存做了容量治理，不是只管写不管清。

---

## 9. 代码速查（复习时按文件看）

- 启动与初始化：lib/main.dart
- 根路由：lib/routes/root.dart
- 状态管理：lib/stores/user.dart、lib/stores/settings.dart
- 本地存储：lib/utils/local.dart、lib/utils/persistence.dart
- 网络封装：lib/utils/fetch.dart、lib/utils/token.dart
- 认证接口：lib/api/auth.dart
- 上传页面：lib/pages/upload/upload_page.dart、upload_actions.dart、upload_options.dart
- 缓存实现：lib/utils/cache.dart
- 任务模型：lib/models/api/task.dart
- 统计视图：lib/pages/home/stats/stats_view.dart、lib/widgets/stats/*
- 设置页面：lib/pages/settings/settings_page.dart

---

## 10. 最后提醒（答题风格）

- 少说“我用了什么库”，多说“我在什么场景下，为了什么问题，用这个库做了什么约束和封装”。
- 对未完成部分不要回避，直接讲“当前状态 + 已有设计 + 下一步计划”。这在腾讯面试里通常比硬撑更加分。
- 每个回答都尽量带一个真实细节：字段名、状态流、关键函数、配置数字。这样可信度会非常高。
