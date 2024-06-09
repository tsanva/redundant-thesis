# description

powershell scripts to make folders redundant. the scripts will only work on windows because it uses `explorer.exe` and `Get-StartApps`.

i made this to make my undergrad thesis redundant (it is written in docx). i use google drive to sync the thesis's folder, and onedrive and icloud to store backups of the folder. for general use, `BackupFolder.ps1` might be useful to backup folders.

# scripts

### `StartWork.ps1`

- starts google drive
- opens the folder in explorer 

### `BackupFolder.ps1`

- starts all cloud storage clients
- copies the folder into the cloud storages' folders

# config

the scripts takes a config file with the file name `config.json`. an example config is provided in `example_config.json`.

### `cloudStorageProviders.appName`

the cloud storage client app name. has to be the same as the output of `Name` property of the `PSObject` on the output of `Get-StartApps`.

### `cloudStorageProviders.targetFolderPath`

the path of the local backup target folder in the cloud storage's virtual drive.

### `sourceFolderPath`

the path of the backup source folder.

# usage

1. `cp example_config.json config.json`
2. edit `config.json` (see [config](#config))
3. start `StartWork.ps1`
4. do work
5. start `BackupFolder.ps1` when done