#!/usr/bin/env node

/*
 * Android 构建初始化脚本（Node 版本）
 *
 * 目标：
 * 1) 统一 Gradle Wrapper 下载源（提升国内网络可达性）
 * 2) 统一项目级与用户级 Gradle 代理配置（避免冲突代理）
 * 3) 注入 ~/.gradle/init.gradle 的 Flutter 保护段（仅 Flutter 项目生效）
 * 4) 执行 flutter pub get，并按需构建 release APK
 *
 * 用法：
 *   1) 按需修改下方 CONFIG
 *   2) 运行：node scripts/init-android-build.js
 */

import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const CONFIG = {
  useProxy: false,
  proxyHost: "127.0.0.1",
  proxyPort: 7890,
  skipBuild: false,
};

const EOL = "\r\n";

function readTextIfExists(filePath) {
  if (!fs.existsSync(filePath)) return "";
  return fs.readFileSync(filePath, "utf8");
}

function writeText(filePath, content) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, content, "utf8");
}

function normalizeLines(content) {
  if (!content) return [];
  return content.split(/\r?\n/);
}

function serializeLines(lines) {
  const filtered = lines.filter((line) => line !== "");
  if (filtered.length === 0) return "";
  return `${filtered.join(EOL)}${EOL}`;
}

function setKeyValueInFile(filePath, key, value) {
  const content = readTextIfExists(filePath);
  const lines = normalizeLines(content);
  const prefix = `${key}=`;
  const next = [];

  let inserted = false;
  for (const line of lines) {
    if (line.trimStart().startsWith(prefix)) {
      if (!inserted) {
        next.push(`${key}=${value}`);
        inserted = true;
      }
      continue;
    }
    next.push(line);
  }

  if (!inserted) next.push(`${key}=${value}`);

  const serialized = serializeLines(next);
  writeText(filePath, serialized);
}

function removeKeyFromFile(filePath, key) {
  if (!fs.existsSync(filePath)) return;

  const content = readTextIfExists(filePath);
  const lines = normalizeLines(content);
  const prefix = `${key}=`;

  const next = lines.filter((line) => !line.trimStart().startsWith(prefix));
  const serialized = serializeLines(next);
  writeText(filePath, serialized);
}

function resolveExecutable(command) {
  if (process.platform !== "win32") return command;
  if (path.extname(command)) return command;
  return `${command}.cmd`;
}

function runChecked(command, args, cwd) {
  const result = spawnSync(resolveExecutable(command), args, {
    cwd,
    stdio: "inherit",
    shell: false,
  });

  if (result.status !== 0) {
    throw new Error(
      `Command failed (${result.status}): ${command} ${args.join(" ")}`,
    );
  }
}

function runBestEffort(command, args, cwd) {
  spawnSync(resolveExecutable(command), args, {
    cwd,
    stdio: "ignore",
    shell: false,
  });
}

function patchWrapperDistribution(wrapperFile) {
  const content = readTextIfExists(wrapperFile);
  if (!content) throw new Error(`Wrapper file not found: ${wrapperFile}`);

  const replaced = content.replace(
    /^distributionUrl=.*/m,
    "distributionUrl=https\\://mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip",
  );

  writeText(wrapperFile, replaced);
}

function patchUserInitGradle(initGradleFile) {
  const guardStart = "// >>> pig_counter_flutter_guard >>>";
  const guardEnd = "// <<< pig_counter_flutter_guard <<<";

  const guard = [
    guardStart,
    "def pigCounterCurrentDir = gradle.startParameter.currentDir",
    "",
    "def pigCounterIsFlutterProject =",
    '        new File(pigCounterCurrentDir, "pubspec.yaml").exists() ||',
    '        new File(pigCounterCurrentDir, "../pubspec.yaml").exists()',
    "",
    "if (pigCounterIsFlutterProject) {",
    "    beforeSettings { settings ->",
    "        settings.pluginManagement {",
    "            repositories {",
    "                maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }",
    "                maven { url 'https://maven.aliyun.com/repository/public' }",
    "                maven { url 'https://maven.aliyun.com/repository/google' }",
    "                google()",
    "                mavenCentral()",
    "                gradlePluginPortal()",
    "            }",
    "        }",
    "    }",
    "    return",
    "}",
    guardEnd,
    "",
  ].join(EOL);

  const defaultInit = [
    "allprojects {",
    "    buildscript {",
    "        repositories {",
    "            maven { url 'https://maven.aliyun.com/repository/public/' }",
    "            maven { url 'https://maven.aliyun.com/repository/google/' }",
    "            maven { url 'https://maven.aliyun.com/repository/gradle-plugin/' }",
    "            maven { url 'https://jitpack.io' }",
    "            mavenCentral()",
    "            google()",
    "            gradlePluginPortal()",
    "        }",
    "    }",
    "    repositories {",
    "        maven { url 'https://maven.aliyun.com/repository/public/' }",
    "        maven { url 'https://maven.aliyun.com/repository/google/' }",
    "        maven { url 'https://jitpack.io' }",
    "        mavenCentral()",
    "        google()",
    "    }",
    "}",
    "",
  ].join(EOL);

  const managedPattern =
    /\/\/ >>> pig_counter_flutter_guard >>>[\s\S]*?\/\/ <<< pig_counter_flutter_guard <<<\s*/g;
  const legacyPattern =
    /def currentDir = gradle\.startParameter\.currentDir\s*def isFlutterProject =\s*new File\(currentDir, "pubspec\.yaml"\)\.exists\(\) \|\|\s*new File\(currentDir, "\.\.\/pubspec\.yaml"\)\.exists\(\)\s*if \(isFlutterProject\) \{\s*return\s*\}\s*/g;

  const oldContent = readTextIfExists(initGradleFile);

  if (!oldContent) {
    writeText(initGradleFile, `${guard}${defaultInit}`);
    return;
  }

  const normalized = oldContent
    .replace(managedPattern, "")
    .replace(legacyPattern, "")
    .trimStart();
  const nextContent = `${guard}${normalized}`;

  if (nextContent !== oldContent) {
    const ts = new Date();
    const stamp = `${ts.getFullYear()}${String(ts.getMonth() + 1).padStart(2, "0")}${String(ts.getDate()).padStart(2, "0")}${String(ts.getHours()).padStart(2, "0")}${String(ts.getMinutes()).padStart(2, "0")}${String(ts.getSeconds()).padStart(2, "0")}`;
    const backup = `${initGradleFile}.bak.${stamp}`;
    fs.copyFileSync(initGradleFile, backup);
    writeText(initGradleFile, nextContent);
    console.log(`Backed up init.gradle to: ${backup}`);
  }
}

function ensureFileExists(filePath, description) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`${description} not found: ${filePath}`);
  }
}

function main() {
  const args = CONFIG;

  const projectRoot = path.resolve(__dirname, "..");
  const androidDir = path.join(projectRoot, "android");
  const wrapperFile = path.join(
    androidDir,
    "gradle",
    "wrapper",
    "gradle-wrapper.properties",
  );
  const gradlePropsFile = path.join(androidDir, "gradle.properties");
  const settingsGradleFile = path.join(androidDir, "settings.gradle.kts");
  const userGradleDir = path.join(os.homedir(), ".gradle");
  const userGradlePropsFile = path.join(userGradleDir, "gradle.properties");
  const initGradleFile = path.join(userGradleDir, "init.gradle");

  ensureFileExists(androidDir, "Android directory");
  ensureFileExists(wrapperFile, "Gradle wrapper properties");
  ensureFileExists(settingsGradleFile, "settings.gradle.kts");

  console.log("[1/7] Configure Gradle wrapper mirror...");
  patchWrapperDistribution(wrapperFile);

  console.log("[2/7] Configure gradle.properties timeouts/proxy...");
  setKeyValueInFile(
    gradlePropsFile,
    "org.gradle.internal.http.connectionTimeout",
    "120000",
  );
  setKeyValueInFile(
    gradlePropsFile,
    "org.gradle.internal.http.socketTimeout",
    "120000",
  );

  fs.mkdirSync(userGradleDir, { recursive: true });

  if (args.useProxy) {
    setKeyValueInFile(
      gradlePropsFile,
      "systemProp.http.proxyHost",
      args.proxyHost,
    );
    setKeyValueInFile(
      gradlePropsFile,
      "systemProp.http.proxyPort",
      String(args.proxyPort),
    );
    setKeyValueInFile(
      gradlePropsFile,
      "systemProp.https.proxyHost",
      args.proxyHost,
    );
    setKeyValueInFile(
      gradlePropsFile,
      "systemProp.https.proxyPort",
      String(args.proxyPort),
    );

    setKeyValueInFile(
      userGradlePropsFile,
      "systemProp.http.proxyHost",
      args.proxyHost,
    );
    setKeyValueInFile(
      userGradlePropsFile,
      "systemProp.http.proxyPort",
      String(args.proxyPort),
    );
    setKeyValueInFile(
      userGradlePropsFile,
      "systemProp.https.proxyHost",
      args.proxyHost,
    );
    setKeyValueInFile(
      userGradlePropsFile,
      "systemProp.https.proxyPort",
      String(args.proxyPort),
    );
  } else {
    removeKeyFromFile(gradlePropsFile, "systemProp.http.proxyHost");
    removeKeyFromFile(gradlePropsFile, "systemProp.http.proxyPort");
    removeKeyFromFile(gradlePropsFile, "systemProp.https.proxyHost");
    removeKeyFromFile(gradlePropsFile, "systemProp.https.proxyPort");

    removeKeyFromFile(userGradlePropsFile, "systemProp.http.proxyHost");
    removeKeyFromFile(userGradlePropsFile, "systemProp.http.proxyPort");
    removeKeyFromFile(userGradlePropsFile, "systemProp.https.proxyHost");
    removeKeyFromFile(userGradlePropsFile, "systemProp.https.proxyPort");
  }

  console.log("[3/7] Check project settings.gradle.kts...");
  ensureFileExists(settingsGradleFile, "settings.gradle.kts");

  console.log("[4/7] Patch user init.gradle for Flutter compatibility...");
  patchUserInitGradle(initGradleFile);

  console.log("[5/7] Stop Gradle daemon...");
  const gradlewBat = path.join(androidDir, "gradlew.bat");
  if (fs.existsSync(gradlewBat)) {
    runBestEffort(gradlewBat, ["--stop"], androidDir);
  }

  console.log("[6/7] Run flutter pub get...");
  runChecked("flutter", ["pub", "get"], projectRoot);

  if (!args.skipBuild) {
    console.log("[7/7] Build release APK...");
    runChecked("flutter", ["build", "apk", "--release"], projectRoot);
    console.log(
      "Done. APK path: build\\app\\outputs\\flutter-apk\\app-release.apk",
    );
  } else {
    console.log("[7/7] Skipped build (--skip-build).");
  }
}

try {
  main();
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
}
