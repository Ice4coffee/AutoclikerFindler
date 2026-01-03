Write-Host === AgeraOPvP  AutoClicker Scan === -ForegroundColor Cyan

$AutoClickers = @(
 autoclicker,opautoclicker,fastclick,free mouse clicker,
 murgaa,tinytask,macro,clicker,gs autoclicker
)

$ScanPaths = @(
 $envUSERPROFILEDownloads,
 $envUSERPROFILEDesktop,
 $envAPPDATA,
 $envLOCALAPPDATA
)

# === ПРОЦЕССЫ ===
Write-Host `n[+] Checking running processes... -ForegroundColor Yellow
Get-Process  ForEach-Object {
    foreach ($ac in $AutoClickers) {
        if ($_.Name -match $ac) {
            try {
                $path = $_.MainModule.FileName
            } catch {
                $path = Access denied
            }

            Write-Host `n[PROCESS DETECTED] -ForegroundColor Red
            Write-Host  Name       $($_.Name)
            Write-Host  PID        $($_.Id)
            Write-Host  Path       $path
        }
    }
}

# === ФАЙЛЫ ===
Write-Host `n[+] Scanning files... -ForegroundColor Yellow
foreach ($path in $ScanPaths) {
    if (Test-Path $path) {
        Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue 
        Where-Object {
            $_.Name -match clickmacroautoclicktinytask -or
            $_.Extension -eq .ahk
        } 
        ForEach-Object {
            Write-Host `n[FILE DETECTED] -ForegroundColor Red
            Write-Host  Name        $($_.Name)
            Write-Host  Extension   $($_.Extension)
            Write-Host  Full path   $($_.FullName)
        }
    }
}

# === АВТОЗАПУСК ===
Write-Host `n[+] Checking startup entries... -ForegroundColor Yellow
Get-CimInstance Win32_StartupCommand  ForEach-Object {
    if ($_.Command -match clickmacroautoclickahk) {
        Write-Host `n[AUTOSTART DETECTED] -ForegroundColor Red
        Write-Host  Name     $($_.Name)
        Write-Host  Command  $($_.Command)
        Write-Host  Location $($_.Location)
    }
}

Write-Host `n=== Scan Finished === -ForegroundColor Green
