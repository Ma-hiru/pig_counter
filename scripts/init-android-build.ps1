param(
    [switch]$UseProxy,
    [string]$ProxyHost = "127.0.0.1",
    [int]$ProxyPort = 7890,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$AndroidDir = Join-Path $ProjectRoot 'android'
$WrapperFile = Join-Path $AndroidDir 'gradle\wrapper\gradle-wrapper.properties'
$GradlePropsFile = Join-Path $AndroidDir 'gradle.properties'
$SettingsGradleFile = Join-Path $AndroidDir 'settings.gradle.kts'
$UserGradleDir = Join-Path $env:USERPROFILE '.gradle'
$UserGradlePropsFile = Join-Path $UserGradleDir 'gradle.properties'
$InitGradleFile = Join-Path $UserGradleDir 'init.gradle'

function Set-KeyValueInFile {
    param(
        [string]$Path,
        [string]$Key,
        [string]$Value
    )

    if (Test-Path $Path) {
        $content = Get-Content -Raw -Path $Path
    } else {
        $content = ''
    }

    $lines = @()
    if ($content) {
        $lines = $content -split "`r?`n"
    }

    $updatedLines = New-Object System.Collections.Generic.List[string]
    $replaced = $false
    $escapedKey = [regex]::Escape($Key)

    foreach ($line in $lines) {
        if ($line -match "^\s*$escapedKey=") {
            if (-not $replaced) {
                $updatedLines.Add("$Key=$Value")
                $replaced = $true
            }
            continue
        }
        if ($line -ne '') {
            $updatedLines.Add($line)
        }
    }

    if (-not $replaced) {
        $updatedLines.Add("$Key=$Value")
    }

    $newContent = ($updatedLines -join "`r`n")
    if ($newContent -and -not $newContent.EndsWith("`n")) {
        $newContent += "`r`n"
    }

    Set-Content -Path $Path -Value $newContent -Encoding UTF8
}

function Remove-KeyFromFile {
    param(
        [string]$Path,
        [string]$Key
    )

    if (-not (Test-Path $Path)) {
        return
    }

    $content = Get-Content -Raw -Path $Path
    if (-not $content) {
        return
    }

    $lines = $content -split "`r?`n"
    $updatedLines = New-Object System.Collections.Generic.List[string]
    $escapedKey = [regex]::Escape($Key)

    foreach ($line in $lines) {
        if ($line -match "^\s*$escapedKey=") {
            continue
        }
        if ($line -ne '') {
            $updatedLines.Add($line)
        }
    }

    $newContent = ($updatedLines -join "`r`n")
    if ($newContent -and -not $newContent.EndsWith("`n")) {
        $newContent += "`r`n"
    }

    Set-Content -Path $Path -Value $newContent -Encoding UTF8
}

function Ensure-PluginMirrorRepositories {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "settings.gradle.kts not found: $Path"
    }
}

function Invoke-CheckedExternal {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,
        [string[]]$Arguments
    )

    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed ($LASTEXITCODE): $Command $($Arguments -join ' ')"
    }
}

if (-not (Test-Path $AndroidDir)) {
    throw "Android directory not found: $AndroidDir"
}

Write-Host "[1/7] Configure Gradle wrapper mirror..."
$wrapperContent = Get-Content -Raw -Path $WrapperFile
$wrapperContent = [regex]::Replace(
    $wrapperContent,
    'distributionUrl=.*',
    'distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip'
)
Set-Content -Path $WrapperFile -Value $wrapperContent -Encoding UTF8

Write-Host "[2/7] Configure gradle.properties timeouts/proxy..."
Set-KeyValueInFile -Path $GradlePropsFile -Key 'org.gradle.internal.http.connectionTimeout' -Value '120000'
Set-KeyValueInFile -Path $GradlePropsFile -Key 'org.gradle.internal.http.socketTimeout' -Value '120000'

if (-not (Test-Path $UserGradleDir)) {
    New-Item -ItemType Directory -Path $UserGradleDir | Out-Null
}

if ($UseProxy) {
    Set-KeyValueInFile -Path $GradlePropsFile -Key 'systemProp.http.proxyHost' -Value $ProxyHost
    Set-KeyValueInFile -Path $GradlePropsFile -Key 'systemProp.http.proxyPort' -Value "$ProxyPort"
    Set-KeyValueInFile -Path $GradlePropsFile -Key 'systemProp.https.proxyHost' -Value $ProxyHost
    Set-KeyValueInFile -Path $GradlePropsFile -Key 'systemProp.https.proxyPort' -Value "$ProxyPort"

    Set-KeyValueInFile -Path $UserGradlePropsFile -Key 'systemProp.http.proxyHost' -Value $ProxyHost
    Set-KeyValueInFile -Path $UserGradlePropsFile -Key 'systemProp.http.proxyPort' -Value "$ProxyPort"
    Set-KeyValueInFile -Path $UserGradlePropsFile -Key 'systemProp.https.proxyHost' -Value $ProxyHost
    Set-KeyValueInFile -Path $UserGradlePropsFile -Key 'systemProp.https.proxyPort' -Value "$ProxyPort"
} else {
    Remove-KeyFromFile -Path $GradlePropsFile -Key 'systemProp.http.proxyHost'
    Remove-KeyFromFile -Path $GradlePropsFile -Key 'systemProp.http.proxyPort'
    Remove-KeyFromFile -Path $GradlePropsFile -Key 'systemProp.https.proxyHost'
    Remove-KeyFromFile -Path $GradlePropsFile -Key 'systemProp.https.proxyPort'

    Remove-KeyFromFile -Path $UserGradlePropsFile -Key 'systemProp.http.proxyHost'
    Remove-KeyFromFile -Path $UserGradlePropsFile -Key 'systemProp.http.proxyPort'
    Remove-KeyFromFile -Path $UserGradlePropsFile -Key 'systemProp.https.proxyHost'
    Remove-KeyFromFile -Path $UserGradlePropsFile -Key 'systemProp.https.proxyPort'
}

Write-Host "[3/7] Patch plugin repositories for Gradle plugin resolution..."
Ensure-PluginMirrorRepositories -Path $SettingsGradleFile

Write-Host "[4/7] Patch user init.gradle for Flutter compatibility..."
$guardStart = '// >>> pig_counter_flutter_guard >>>'

$guard = @'
// >>> pig_counter_flutter_guard >>>
def pigCounterCurrentDir = gradle.startParameter.currentDir

def pigCounterIsFlutterProject =
        new File(pigCounterCurrentDir, "pubspec.yaml").exists() ||
        new File(pigCounterCurrentDir, "../pubspec.yaml").exists()

if (pigCounterIsFlutterProject) {
    beforeSettings { settings ->
        settings.pluginManagement {
            repositories {
                maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
                maven { url 'https://maven.aliyun.com/repository/public' }
                maven { url 'https://maven.aliyun.com/repository/google' }
                google()
                mavenCentral()
                gradlePluginPortal()
            }
        }
    }
    return
}
// <<< pig_counter_flutter_guard <<<
'@

if (Test-Path $InitGradleFile) {
    $initContent = Get-Content -Raw -Path $InitGradleFile
    $managedPattern = '(?s)// >>> pig_counter_flutter_guard >>>.*?// <<< pig_counter_flutter_guard <<<\s*'
    $legacyPattern = '(?s)def currentDir = gradle\.startParameter\.currentDir\s*def isFlutterProject =\s*new File\(currentDir, "pubspec\.yaml"\)\.exists\(\) \|\|\s*new File\(currentDir, "../pubspec\.yaml"\)\.exists\(\)\s*if \(isFlutterProject\) \{\s*return\s*\}\s*'

    $normalized = [regex]::Replace($initContent, $managedPattern, '')
    $normalized = [regex]::Replace($normalized, $legacyPattern, '')

    if (("$guard`r`n$normalized") -ne $initContent) {
        $backup = "$InitGradleFile.bak.$(Get-Date -Format yyyyMMddHHmmss)"
        Copy-Item $InitGradleFile $backup
        Set-Content -Path $InitGradleFile -Value ($guard + "`r`n" + $normalized.TrimStart()) -Encoding UTF8
        Write-Host "Backed up init.gradle to: $backup"
    }
} else {
    $defaultInit = @'
allprojects {
    buildscript {
        repositories {
            maven { url ''https://maven.aliyun.com/repository/public/'' }
            maven { url ''https://maven.aliyun.com/repository/google/'' }
            maven { url ''https://maven.aliyun.com/repository/gradle-plugin/'' }
            maven { url ''https://jitpack.io'' }
            mavenCentral()
            google()
            gradlePluginPortal()
        }
    }
    repositories {
        maven { url ''https://maven.aliyun.com/repository/public/'' }
        maven { url ''https://maven.aliyun.com/repository/google/'' }
        maven { url ''https://jitpack.io'' }
        mavenCentral()
        google()
    }
}
'@
    $defaultInit = $defaultInit -replace "''", "'"
    Set-Content -Path $InitGradleFile -Value ($guard + "`r`n" + $defaultInit) -Encoding UTF8
}

Write-Host "[5/7] Stop Gradle daemon..."
Set-Location $AndroidDir
if (Test-Path '.\gradlew.bat') {
    & .\gradlew.bat --stop | Out-Null
}

Write-Host "[6/7] Run flutter pub get..."
Set-Location $ProjectRoot
Invoke-CheckedExternal -Command 'flutter' -Arguments @('pub', 'get')

if (-not $SkipBuild) {
    Write-Host "[7/7] Build release APK..."
    Invoke-CheckedExternal -Command 'flutter' -Arguments @('build', 'apk', '--release')
    Write-Host "Done. APK path: build\\app\\outputs\\flutter-apk\\app-release.apk"
} else {
    Write-Host "[7/7] Skipped build (-SkipBuild)."
}
