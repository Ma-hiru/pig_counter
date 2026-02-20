# pig_counter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Android 构建初始化（Node 版）

脚本路径：`scripts/init-android-build.js`

模块类型：`ESM`（通过 `scripts/package.json` 的 `type: module` 启用）

使用方式：

- 先修改 `scripts/init-android-build.js` 顶部的 `CONFIG`（如 `useProxy`、`proxyHost`、`proxyPort`、`skipBuild`）
- 再运行：`node scripts/init-android-build.js`

功能说明：

- 设置 Gradle Wrapper 镜像
- 统一处理项目级/用户级 Gradle 代理，避免冲突
- 修补 `~/.gradle/init.gradle` 的 Flutter 兼容段
- 执行 `flutter pub get`，并按需执行 `flutter build apk --release`
