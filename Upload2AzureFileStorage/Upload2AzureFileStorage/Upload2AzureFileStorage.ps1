Param(
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$directory
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$azureSubscriptionType    
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$serviceType
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$storageAccount
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$fileShareName
    ,[string]$filePath
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$storageAccountKey
    ,[string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$journalFileLocation
)
Write-Host "Entering script Upload2AzureFileStorage.ps1... ";
Write-Host "Parameter Validation...";
Write-Host "Directory:                   $directory";
Write-Host "Azure Subscription Type:     $azureSubscriptionType";
Write-Host "Service Type:                $serviceType";
Write-Host "Storage Account:             $storageAccount";
Write-Host "File Share Name:             $fileShareName";
Write-Host "File Path:                   $filePath";

<#############################################
Functions used in Upload2AzureFileStorage
##############################################>
function Get-CleanPath ([string]$filePath )
{
    try
    {
        $filePath = $filePath.TrimEnd('\');
        $filePath = $filePath.TrimEnd('/');
        $filePath = $filePath.Replace('\', '/');
        return $filePath;
    }
    catch
    {
        Write-Host "Could not parse value for $filePath : $_ " ;      
        return ""; 
    }
}
function Get-AzureStorageEndpointAddress ([string]$azureSubscriptionType, [string]$serviceType)
{
    $storageURL = '';
    $endpointAddress = '';
    if ($azureSubscriptionType -eq 'azuregovernment')
    {
        $storageURL = 'core.usgovcloudapi.net';
    }
    elseif ($azureSubscriptionType -eq 'azurepublic')
    {
        $storageURL = 'core.windows.net';
    }
    else
    {
        Throw "Unable to determine correct Azure endpoint from the Azure Subscription Type: $azureSubscriptionType ";
    }

    if($serviceType -eq 'file')
    {
        $endpointAddress = "$serviceType.$storageURL"
    }
    elseif ($serviceType -eq 'blob')
    {
        $endpointAddress = "$serviceType.$storageURL"
        Throw 'Upload to blob storage is not currently supported.';
    }
    else
    {
        Throw "Unable to determine correct type of Azure storage service type: $serviceType ";
    }
    return $endpointAddress;
}
function Get-FullEndpointAddress ([string]$endpointAddress, [string]$storageAccount, [string]$fileShareName, [string]$path, [string]$leaf)
{
    if ($path.Length -gt 0)
    {            
        $destination = "https://$storageAccount.$endpointAddress/$fileShareName/$path/$leaf"
    }
    else
    {
        $destination = "https://$storageAccount.$endpointAddress/$fileShareName/$leaf"
    }
    return $destination
}
function New-JournalFileLocation ([string]$newJournalFileLocation)
{
    if (Test-Path $newJournalFileLocation.trim())
    { 
        try
        {
            Remove-Item "$newJournalFileLocation\*.*" -Force
        }
        catch
        {
            Write-Host "Unable to clear the current AzCopy journal file location."
            Throw $_.Exception.Message 
            return $null;
        }
    }
    else
    {
        try
        {
            New-Item -Path $newJournalFileLocation -ItemType Directory -Force | out-null
        } 
        catch
        { 
            Write-Host "Unable to create a new AzCopy journal file location of $newJournalFileLocation."
            Throw $_.Exception.Message 
            return $null;
        }        
    }
    return $newJournalFileLocation
}

<####################################################
Attempt to upload to Azure Storage Using AzCopy
####################################################>
try 
{
    $uploadFolderLeaf = Split-Path -Path $directory -Leaf
    $endpointAddress = Get-AzureStorageEndpointAddress -azureSubscriptionType $azureSubscriptionType -serviceType $serviceType    
    $path = Get-CleanPath -filePath $filePath
    $fullendpointAddress = Get-FullEndpointAddress -endpointAddress $endpointAddress -storageAccount $storageAccount -fileShareName $fileShareName -path $path -leaf $uploadFolderLeaf
    $AzCopyJournalFileLocation = New-JournalFileLocation $journalFileLocation    
    if (-Not( Test-Path $AzCopyJournalFileLocation.trim())){ Throw "The journal file location of $AzCopyJournalFileLocation is invalid."}
    Write-Host "Upload Folder Leaf:          $uploadFolderLeaf"
    Write-Host "Azure Storage Destination:   $fullendpointAddress";
    Write-Host "";
    & 'C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe' /Source:$directory /Dest:$fullendpointAddress /DestKey:$storageAccountKey /S /Z:$AzCopyJournalFileLocation
} 
catch [System.Exception] 
{
    Write-Host $_.Exception.ToString()
}