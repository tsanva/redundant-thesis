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

# read the configuration file
$configFilePath = "config.json"
$config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json

# get gdrive app id
$gDrive = Get-StartApps | Where-Object { $_.Name -eq "$($config.cloudStorageProviders[0].appName)" }

# start gdrive
Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\$($gDrive.AppID)"
if (-not (Wait-ForProcess -processName $config.cloudStorageProviders[0].processName)) {
    throw "Google Drive did not start within the timeout period."
}

# Open the specified folder
Start-Process "explorer.exe" -ArgumentList $config.folderPath