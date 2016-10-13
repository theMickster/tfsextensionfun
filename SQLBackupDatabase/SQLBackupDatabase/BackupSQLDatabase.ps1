param(
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $instance,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $database,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $filename,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $BackupAction,   
    [string] $BackupSetDescription,
    [string] $CopyOnlyString
     
)
$WarningPreference = 'SilentlyContinue'
Write-Host "Entering script BackupSQLDatabase.ps1.. "
$Today = $(Get-Date -f yyyyMMdd_hhmmss)
$CopyOnly = [System.Convert]::ToBoolean($CopyOnlyString) 
Write-Host "Parameter Validation..."
Write-Host "SQL Database Server: $instance"
Write-Host "SQL Database Name: $database"
Write-Host "Formatted date: $Today"
Write-Host "Backup Action: $BackupAction"
Write-Host "Copy Only Backup?: $CopyOnly"
Write-Host "Backup Set Description: $BackupSetDescription"
$BackupAction = $BackupAction.ToLower();
try 
{
    if ($BackupAction -ne 'database' -and $BackupAction -ne 'log')
    {
        throw ('Invalid backup action passed into BackupSQLDatabase.ps1. Valid values: database or log.')
    }
    $filename = $filename.TrimEnd('.bak');
    $filename = $filename.TrimEnd('.trn');
    $filename = $filename + '_' + $Today
    if ($BackupAction -eq 'database')
    {
        $filename = $filename + '.bak'
    }
    else 
    {
        $filename = $filename + '.trn'
    }
    Write-Host "Backup Filename: $filename"
    if (-not(Get-Module -name 'SQLPS')) 
    {
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) 
        {
            Import-Module SQLPS -Force -DisableNameChecking
        }
        else
        {
            Write-Host 'ERROR: SQL PowerShell module not found on build server.'
            exit 1
        }
    }

    if ($CopyOnly)
    {
        Backup-SqlDatabase -ServerInstance $instance -Database $database -CompressionOption On -BackupAction $BackupAction `
                            -BackupFile $filename -Initialize -CopyOnly -BackupSetDescription $BackupSetDescription
    }
    else
    {
            Backup-SqlDatabase -ServerInstance $instance -Database $database -CompressionOption On -BackupAction $BackupAction `
                            -BackupFile $filename -Initialize -CopyOnly -BackupSetDescription $BackupSetDescription
    }
}
catch
{
    Write-Host "##vso[task.logissue type=error;code=" $_.Exception.Message ";TaskName=SQLBackupDatabase]"
    throw
}