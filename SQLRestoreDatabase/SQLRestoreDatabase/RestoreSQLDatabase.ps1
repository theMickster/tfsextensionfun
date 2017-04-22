param(
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $instance,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $database,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $fullFilePath
)
$WarningPreference = 'SilentlyContinue'
Write-Host "Entering script BackupSQLDatabase.ps1.. "
$Today = $(Get-Date -f yyyyMMdd)

Write-Host "Parameter Validation..."
Write-Host "SQL Database Server: $instance"
Write-Host "SQL Database Name: $database"
Write-Host "Formatted date: $Today"
Write-Host "Full file path and Name: $fullFilePath"
try 
{
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
    $restoreCmd = "USE master;
                ALTER DATABASE $database SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                RESTORE DATABASE $database 
                FROM  DISK = '$fullFilePath' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
                ALTER DATABASE $database SET MULTI_USER;"
    
    $connectionString = "Data Source=$instance; Integrated Security=SSPI; Initial Catalog=master";
    $connection = new-object system.data.SqlClient.SQLConnection($connectionString);
    $connection.Open();
    $SQLCMD = New-Object System.Data.SqlClient.SqlCommand
    $SQLCMD.CommandText = $restoreCmd
    $SQLCMD.Connection = $connection
    $SQLCMD.ExecuteNonQuery()
    $connection.Close();
}
catch
{
    Write-Host "##vso[task.logissue type=error;code=" $_.Exception.Message ";TaskName=SQLBackupDatabase]"
    throw
}
finally
{
    if ($connection.State -eq 'Open') { $connection.Close(); }
}