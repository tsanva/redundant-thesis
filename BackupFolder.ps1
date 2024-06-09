# Function to wait for a process to start
function Wait-ForProcess {
    param (
        [string]$processName,
        [int]$timeout = 30
    )

    $startTime = Get-Date
    while (((Get-Date) - $startTime).TotalSeconds -lt $timeout) {
        if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
            return $true
        }
        Start-Sleep -Seconds 1
    }
    return $false
}

# Read configuration from JSON file
$configFilePath = "config.json"
$config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

# Start all processes
foreach ($cloudStorageProvider in $config.cloudStorageProviders) {
    $cloudStorageApp = Get-StartApps | Where-Object { $_.Name -eq "$($cloudStorageProvider.appName)" }
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\$($cloudStorageApp.AppID)"
}

# Wait for all processes to start
foreach ($cloudStorageProvider in $config.cloudStorageProviders) {
    if (-not (Wait-ForProcess -processName $cloudStorageProvider.processName)) {
        throw "$($cloudStorageProvider.appName) did not start within the timeout period."
    }
}

# backup to cloud storage
$backupFolderName = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
foreach ($cloudStorageProvider in $config.cloudStorageProviders) {
    $targetFolderPath = Join-Path -Path $cloudStorageProvider.targetFolderPath -ChildPath $backupFolderName
    Copy-Item -Path $config.folderPath -Destination $targetFolderPath -Recurse
}