Write-Host "=== Icef4ry | AutoClicker Scan ===" -ForegroundColor Cyan

$AutoClickers = @(
 "autoclicker","opautoclicker","fastclick","free mouse clicker",
 "murgaa","tinytask","macro","clicker","gs autoclicker"
)

$MacroTools = @(
 "autohotkey","logitech","ghub","bloody","razer","steelseries","corsair"
)

# === ПРОЦЕССЫ ===
Write-Host "`n[+] Checking running processes..." -ForegroundColor Yellow
Get-Process | ForEach-Object {
    foreach ($ac in $AutoClickers) {
        if ($_.Name -match $ac) {
            Write-Host "AUTOCLICKER PROCESS FOUND: $($_.Name)" -ForegroundColor Red
        }
    }
    foreach ($mt in $MacroTools) {
        if ($_.Name -match $mt) {
            Write-Host "MACRO SOFTWARE DETECTED: $($_.Name)" -ForegroundColor Magenta
        }
    }
}

# === ФАЙЛЫ ===
Write-Host "`n[+] Scanning common folders..." -ForegroundColor Yellow
$ScanPaths = @(
 "$env:USERPROFILE\Downloads",
 "$env:USERPROFILE\Desktop",
 "$env:APPDATA",
 "$env:LOCALAPPDATA"
)

foreach ($path in $ScanPaths) {
    if (Test-Path $path) {
        Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -match "click|macro|autoclick|tinytask" -or
            $_.Extension -eq ".ahk"
        } |
        ForEach-Object {
            Write-Host "SUSPICIOUS FILE FOUND: $($_.FullName)" -ForegroundColor Red
        }
    }
}

# === АВТОЗАПУСК ===
Write-Host "`n[+] Checking startup entries..." -ForegroundColor Yellow
Get-CimInstance Win32_StartupCommand | ForEach-Object {
    if ($_.Command -match "click|macro|autoclick|ahk") {
        Write-Host "SUSPICIOUS AUTOSTART: $($_.Command)" -ForegroundColor Red
    }
}

Write-Host "`n=== Scan Finished ===" -ForegroundColor Green
