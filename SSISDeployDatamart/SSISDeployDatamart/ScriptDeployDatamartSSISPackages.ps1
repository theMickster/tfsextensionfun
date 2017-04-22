param
(
    [string] $WorkingDirectory,
    [string] $SQLServerName,
    [string] $ISCatalogFolderName,
    [string] $DBNameOLTP,
    [string] $DBNameAcq,
    [string] $DBNameQuery
)

# Report parameters passed in
Write-Host ("Parameters passed in:")
Write-Host (" ")
Write-Host ("     WorkingDirectory: " + $WorkingDirectory)
Write-Host ("        SQLServerName: " + $SQLServerName)
Write-Host ("  ISCatalogFolderName: " + $ISCatalogFolderName)
Write-Host ("           DBNameOLTP: " + $DBNameOLTP)
Write-Host ("            DBNameAcq: " + $DBNameAcq)
Write-Host ("          DBNameQuery: " + $DBNameQuery)


# Name of SSIS Catalog DB
$SSISCatalog = "SSISDB"

$SSISPackageNameList = "BatchAuditEnd", "BatchAuditStart", "Expunge_patients_from_acquisition", "Load_Acquisition", "Load_Base", "Load_Query"
$SSISPackageNameExt = ".ispac"

$SSISReleaseFolder = $WorkingDirectory

# Create SSIS Package Parameters

$ApplicationName = "/webiznet_dev"
$AuditID = 1

$BatchMasterIdEnd  = 1  # WebIZ Daily Acquisition
$BatchNameEnd      = "WebIZ Daily Acquisition"
$BatchPackageIdEnd = 53  # BatchAuditEnd

$BatchMasterIdStart  = 1  # WebIZ Daily Acquisition
$BatchNameStart      = "WebIZ Daily Acquisition"
$BatchPackageIdStart = 52  # BatchAuditStart

$BatchMasterIdExpunge  = 1  # WebIZ Daily Acquisition
$BatchNameExpunge      = "WebIZ Daily Acquisition"
$BatchPackageIdExpunge = 128
$PackageNameExpunge    = "Expunge_patients_from_acquisition"

$BatchMasterIdAcq   = 1  # WebIZ Daily Acquisition
$BatchMasterIdBase  = 5  # WebIZ Daily Base Layer
$BatchMasterIdQuery = 9  # WebIZ Daily Query


# Create a class to hold the SSIS Package Parameters

Write-Host (" ")
Write-Host ("Creating SSIS Package Parameters...")

class ISCatalogEnvVar
{
    [string]$Package
    [string]$Name
    [System.TypeCode]$Type
    [string]$Desc
    [string]$Value
}


# Create a list of SSIS Package Parameters

$SSISPackageParamList = [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(),
                        [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(),
                        [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(),
                        [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(),
                        [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(),
                        [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new(), [ISCatalogEnvVar]::new()


# Set BATCHAUDITEND Parameters

$SSISPackageParamList[0].Package = "BatchAuditEnd"
$SSISPackageParamList[0].Name    = "WebIZ_Acquisition_ConnectionString"
$SSISPackageParamList[0].Type    = [System.TypeCode]::String
$SSISPackageParamList[0].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[0].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[1].Package = "BatchAuditEnd"
$SSISPackageParamList[1].Name    = "application_name"
$SSISPackageParamList[1].Type    = [System.TypeCode]::String
$SSISPackageParamList[1].Desc    = ""
$SSISPackageParamList[1].Value   = $ApplicationName

$SSISPackageParamList[2].Package = "BatchAuditEnd"
$SSISPackageParamList[2].Name    = "audit_id"
$SSISPackageParamList[2].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[2].Desc    = ""
$SSISPackageParamList[2].Value   = $AuditID.ToString()

$SSISPackageParamList[3].Package = "BatchAuditEnd"
$SSISPackageParamList[3].Name    = "batch_master_id"
$SSISPackageParamList[3].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[3].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[3].Value   = $BatchMasterIdEnd.ToString()

$SSISPackageParamList[4].Package = "BatchAuditEnd"
$SSISPackageParamList[4].Name    = "batch_name"
$SSISPackageParamList[4].Type    = [System.TypeCode]::String
$SSISPackageParamList[4].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[4].Value   = $BatchNameEnd

$SSISPackageParamList[5].Package = "BatchAuditEnd"
$SSISPackageParamList[5].Name    = "batch_package_id"
$SSISPackageParamList[5].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[5].Desc    = "BatchAuditEnd"
$SSISPackageParamList[5].Value   = $BatchPackageIdEnd.ToString()


# Set BATCHAUDITSTART Parameters

$SSISPackageParamList[6].Package = "BatchAuditStart"
$SSISPackageParamList[6].Name    = "WebIZ_Acquisition_ConnectionString"
$SSISPackageParamList[6].Type    = [System.TypeCode]::String
$SSISPackageParamList[6].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[6].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[7].Package = "BatchAuditStart"
$SSISPackageParamList[7].Name    = "application_name"
$SSISPackageParamList[7].Type    = [System.TypeCode]::String
$SSISPackageParamList[7].Desc    = ""
$SSISPackageParamList[7].Value   = $ApplicationName

$SSISPackageParamList[8].Package = "BatchAuditStart"
$SSISPackageParamList[8].Name    = "audit_id"
$SSISPackageParamList[8].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[8].Desc    = ""
$SSISPackageParamList[8].Value   = $AuditID.ToString()

$SSISPackageParamList[9].Package = "BatchAuditStart"
$SSISPackageParamList[9].Name    = "batch_master_id"
$SSISPackageParamList[9].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[9].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[9].Value   = $BatchMasterIdStart.ToString()

$SSISPackageParamList[10].Package = "BatchAuditStart"
$SSISPackageParamList[10].Name    = "batch_name"
$SSISPackageParamList[10].Type    = [System.TypeCode]::String
$SSISPackageParamList[10].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[10].Value   = $BatchNameStart

$SSISPackageParamList[11].Package = "BatchAuditStart"
$SSISPackageParamList[11].Name    = "batch_package_id"
$SSISPackageParamList[11].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[11].Desc    = "BatchAuditStart"
$SSISPackageParamList[11].Value   = $BatchPackageIdStart.ToString()


# Set EXPUNGE_PATIENTS_FROM_ACQUISITION Parameters

$SSISPackageParamList[12].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[12].Name    = "WebIZ_Acquisition_ADO_ConnectionString"
$SSISPackageParamList[12].Type    = [System.TypeCode]::String
$SSISPackageParamList[12].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[12].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[13].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[13].Name    = "WebIZ_Acquisition_OLE_DB_ConnectionString"
$SSISPackageParamList[13].Type    = [System.TypeCode]::String
$SSISPackageParamList[13].Desc    = ""
$SSISPackageParamList[13].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[14].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[14].Name    = "Webiz_ADO_ConnectionString"
$SSISPackageParamList[14].Type    = [System.TypeCode]::String
$SSISPackageParamList[14].Desc    = ""
$SSISPackageParamList[14].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_OLTP>;Integrated Security=True;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_OLTP>", $DBNameOLTP)

$SSISPackageParamList[15].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[15].Name    = "Webiz_OLE_DB_ConnectionString"
$SSISPackageParamList[15].Type    = [System.TypeCode]::String
$SSISPackageParamList[15].Desc    = ""
$SSISPackageParamList[15].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_OLTP>;Trusted_Connection=Yes;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_OLTP>", $DBNameOLTP)

$SSISPackageParamList[16].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[16].Name    = "application_name"
$SSISPackageParamList[16].Type    = [System.TypeCode]::String
$SSISPackageParamList[16].Desc    = ""
$SSISPackageParamList[16].Value   = $ApplicationName

$SSISPackageParamList[17].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[17].Name    = "audit_id"
$SSISPackageParamList[17].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[17].Desc    = ""
$SSISPackageParamList[17].Value   = $AuditID.ToString()

$SSISPackageParamList[18].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[18].Name    = "batch_master_id"
$SSISPackageParamList[18].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[18].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[18].Value   = $BatchMasterIdExpunge.ToString()

$SSISPackageParamList[19].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[19].Name    = "batch_name"
$SSISPackageParamList[19].Type    = [System.TypeCode]::String
$SSISPackageParamList[19].Desc    = $BatchNameExpunge
$SSISPackageParamList[19].Value   = $BatchNameExpunge

$SSISPackageParamList[20].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[20].Name    = "batch_package_id"
$SSISPackageParamList[20].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[20].Desc    = "Expunge_patients_from_acquisition"
$SSISPackageParamList[20].Value   = $BatchPackageIdExpunge.ToString()

$SSISPackageParamList[21].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[21].Name    = "package_name"
$SSISPackageParamList[21].Type    = [System.TypeCode]::String
$SSISPackageParamList[21].Desc    = "Expunge_patients_from_acquisition"
$SSISPackageParamList[21].Value   = $PackageNameExpunge

$SSISPackageParamList[22].Package = "Expunge_patients_from_acquisition"
$SSISPackageParamList[22].Name    = "sor_database_name"
$SSISPackageParamList[22].Type    = [System.TypeCode]::String
$SSISPackageParamList[22].Desc    = "WebIZ OLTP Database"
$SSISPackageParamList[22].Value   = $DBNameOLTP


# Set ACQUISITION Parameters

$SSISPackageParamList[23].Package = "Load_Acquisition"
$SSISPackageParamList[23].Name    = "WebIZ_Acquisition_ADO_ConnectionString"
$SSISPackageParamList[23].Type    = [System.TypeCode]::String
$SSISPackageParamList[23].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[23].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[24].Package = "Load_Acquisition"
$SSISPackageParamList[24].Name    = "WebIZ_Acquisition_OLE_DB_ConnectionString"
$SSISPackageParamList[24].Type    = [System.TypeCode]::String
$SSISPackageParamList[24].Desc    = ""
$SSISPackageParamList[24].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[25].Package = "Load_Acquisition"
$SSISPackageParamList[25].Name    = "Webiz_ADO_ConnectionString"
$SSISPackageParamList[25].Type    = [System.TypeCode]::String
$SSISPackageParamList[25].Desc    = ""
$SSISPackageParamList[25].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_OLTP>;Integrated Security=True;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_OLTP>", $DBNameOLTP)

$SSISPackageParamList[26].Package = "Load_Acquisition"
$SSISPackageParamList[26].Name    = "Webiz_OLE_DB_ConnectionString"
$SSISPackageParamList[26].Type    = [System.TypeCode]::String
$SSISPackageParamList[26].Desc    = ""
$SSISPackageParamList[26].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_OLTP>;Trusted_Connection=Yes;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_OLTP>", $DBNameOLTP)

$SSISPackageParamList[27].Package = "Load_Acquisition"
$SSISPackageParamList[27].Name    = "application_name"
$SSISPackageParamList[27].Type    = [System.TypeCode]::String
$SSISPackageParamList[27].Desc    = ""
$SSISPackageParamList[27].Value   = $ApplicationName

$SSISPackageParamList[28].Package = "Load_Acquisition"
$SSISPackageParamList[28].Name    = "audit_id"
$SSISPackageParamList[28].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[28].Desc    = ""
$SSISPackageParamList[28].Value   = $AuditID.ToString()

$SSISPackageParamList[29].Package = "Load_Acquisition"
$SSISPackageParamList[29].Name    = "batch_master_id"
$SSISPackageParamList[29].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[29].Desc    = "WebIZ Daily Acquisition"
$SSISPackageParamList[29].Value   = $BatchMasterIdAcq.ToString()

$SSISPackageParamList[30].Package = "Load_Acquisition"
$SSISPackageParamList[30].Name    = "sor_database_name"
$SSISPackageParamList[30].Type    = [System.TypeCode]::String
$SSISPackageParamList[30].Desc    = "WebIZ OLTP Database"
$SSISPackageParamList[30].Value   = $DBNameOLTP


# Set BASE Parameters

$SSISPackageParamList[31].Package = "Load_Base"
$SSISPackageParamList[31].Name    = "WebIZ_Acquisition_ADO_ConnectionString"
$SSISPackageParamList[31].Type    = [System.TypeCode]::String
$SSISPackageParamList[31].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[31].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[32].Package = "Load_Base"
$SSISPackageParamList[32].Name    = "application_name"
$SSISPackageParamList[32].Type    = [System.TypeCode]::String
$SSISPackageParamList[32].Desc    = ""
$SSISPackageParamList[32].Value   = $ApplicationName

$SSISPackageParamList[33].Package = "Load_Base"
$SSISPackageParamList[33].Name    = "audit_id"
$SSISPackageParamList[33].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[33].Desc    = ""
$SSISPackageParamList[33].Value   = $AuditID.ToString()

$SSISPackageParamList[34].Package = "Load_Base"
$SSISPackageParamList[34].Name    = "batch_master_id"
$SSISPackageParamList[34].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[34].Desc    = "WebIZ Daily Base Layer"
$SSISPackageParamList[34].Value   = $BatchMasterIdBase.ToString()


# Set QUERY Parameters

$SSISPackageParamList[35].Package = "Load_Query"
$SSISPackageParamList[35].Name    = "WebIZ_Acquisition_ADO_ConnectionString"
$SSISPackageParamList[35].Type    = [System.TypeCode]::String
$SSISPackageParamList[35].Desc    = "Default connection string to the WebIZ Acquisition database."
$SSISPackageParamList[35].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Acquisition>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Acquisition>", $DBNameAcq)

$SSISPackageParamList[36].Package = "Load_Query"
$SSISPackageParamList[36].Name    = "WebIZ_Query_ADO_ConnectionString"
$SSISPackageParamList[36].Type    = [System.TypeCode]::String
$SSISPackageParamList[36].Desc    = "Default connection string to the WebIZ Query database."
$SSISPackageParamList[36].Value   = "Data Source=<SQLServerName>;Initial Catalog=<WebIZ_Query>;Trusted_Connection=Yes;".Replace("<SQLServerName>", $SQLServerName).Replace("<WebIZ_Query>", $DBNameQuery)

$SSISPackageParamList[37].Package = "Load_Query"
$SSISPackageParamList[37].Name    = "application_name"
$SSISPackageParamList[37].Type    = [System.TypeCode]::String
$SSISPackageParamList[37].Desc    = ""
$SSISPackageParamList[37].Value   = $ApplicationName

$SSISPackageParamList[38].Package = "Load_Query"
$SSISPackageParamList[38].Name    = "audit_id"
$SSISPackageParamList[38].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[38].Desc    = ""
$SSISPackageParamList[38].Value   = $AuditID.ToString()

$SSISPackageParamList[39].Package = "Load_Query"
$SSISPackageParamList[39].Name    = "batch_master_id"
$SSISPackageParamList[39].Type    = [System.TypeCode]::Int32
$SSISPackageParamList[39].Desc    = "WebIZ Daily Query"
$SSISPackageParamList[39].Value   = $BatchMasterIdQuery.ToString()


# Store the IntegrationServices Assembly namespace to avoid typing it every time
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

# Load the IntegrationServices Assembly
[Reflection.Assembly]::LoadWithPartialName($ISNamespace)

Write-Host ("Connecting to SQL Server '" + $SQLServerName + "'...")

# Create a connection to the server
$SQLConnectionString = "Data Source=$SQLServerName;Initial Catalog=master;Integrated Security=SSPI;"
Write-Host ("Connection string: " + $SQLConnectionString)
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection $SQLConnectionString

$IntegrationServices = New-Object "$ISNamespace.IntegrationServices" $SQLConnection

# Get the IS Catalog
$Catalog = $IntegrationServices.Catalogs[$SSISCatalog]

if (!$Catalog)
{   
    # Integration Services Catalogs SSISDB object does not exist
    # Do not attempt to create the catalog, this should be done manually, just exit and fail
    Write-Host (" ")
    Write-Host ("The IS Catalog '" + $SSISCatalog + "' does not already exist.  Please create this catalog before running this script.")
    Write-Host ("Script Terminated.")

    # Exit with non-normal termination code to be picked up by TFS to terminate the build
    Exit 1
}

# Check for IS Catalog Folder name
$Folder = $Catalog.Folders[$ISCatalogFolderName]

if (!$Folder)
{
    #Create a new IS Catalog folder
    Write-Host ("Creating IS Catalog Folder '" + $ISCatalogFolderName + "'...")
    $Folder = New-Object "$ISNamespace.CatalogFolder" ($Catalog, $ISCatalogFolderName, $ISCatalogFolderName)            
    $Folder.Create()  
}

ForEach ($SSISPackageName in $SSISPackageNameList)
{
    # Read the SSIS package file and deploy it to the folder

    Write-Host (" ")
    Write-Host ("Deploying SSIS Package '" + $SSISPackageName + "' to IS Catalog Project '" + $SSISPackageName + "'...")

    # Read SSIS Package into memory
    $SSISPackagePath = Join-Path $SSISReleaseFolder ($SSISPackageName + $SSISPackageNameExt) -Resolve
    [byte[]] $ProjectFile = [System.IO.File]::ReadAllBytes($SSISPackagePath)

    # Deploy SSIS Package
    $Folder.DeployProject($SSISPackageName, $ProjectFile)

    # Create name of IS Catalog Environment
    $ISCatalogEnvironmentName = $SSISPackageName + "_Vars"

    # Reference new IS Catalog Environment
    $Environment = $Folder.Environments[$ISCatalogEnvironmentName]

    if (!$Environment)
    {
        Write-Host ("Creating IS Catalog Environment '" + $ISCatalogEnvironmentName + "'...")
        $Environment = New-Object "$ISNamespace.EnvironmentInfo" ($folder, $ISCatalogEnvironmentName, $ISCatalogEnvironmentName)
        $Environment.Create()            
    }

    # Reference new IS Catalog Project
    $Project = $Folder.Projects[$SSISPackageName]

    # Get the IS Catalog Environment reference
    $Ref = $Project.References[$ISCatalogEnvironmentName, $Folder.Name]

    if (!$Ref)
    {
        # Add reference to IS Catalog Project to refer to this IS Catalog Environment
        Write-Host ("Adding reference for IS Catalog Environment '" + $ISCatalogEnvironmentName + "' to IS Catalog Project '" + $SSISPackageName + "'...")
        Write-Host (" ")
        $Project.References.Add($ISCatalogEnvironmentName, $Folder.Name)
        $Project.Alter() 
    }

    ForEach ($SSISPackageParam in $SSISPackageParamList)
    {
        if ($SSISPackageParam.Package -eq $SSISPackageName)
        {

            # Check for IS Catalog Environment Variable
            $Variable = $Environment.Variables[$SSISPackageParam.Name]

            if (!$Variable)
            {
                # Add a variable to the new IS Catalog Environment

                Write-Host ("Adding environment variable '" + $SSISPackageParam.Name + "' to '" + $ISCatalogEnvironmentName + "'...")
                
                # Args: variable name, type, value, sensitivity, description
                $Environment.Variables.Add($SSISPackageParam.Name,
                                           $SSISPackageParam.Type,
                                           $SSISPackageParam.Value,
                                           $false,
                                           $SSISPackageParam.Desc)
                #$Environment.Alter()
                #$Variable = $Environment.Variables[$SSISPackageParam.Name];
            }

            # Set IS Catalog Project reference to IS Catalog Environment variable
            $Project.Parameters[$SSISPackageParam.Name].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, 
                                                            $SSISPackageParam.Name)
        }
    }

    # Save all IS Catalog Environment variables
    $Environment.Alter()

    # Save all IS Catalog Project parameter references to IS Catalog Environment variables
    $Project.Alter()

    # Validate IS Catalog Project

    Write-Host (" ")
    Write-Host ("Validating IS Catalog Project '" + $SSISPackageName + "'...")
                 
    <#
        https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.integrationservices.packageinfo.validate(v=sql.130).aspx

        use32RuntimeOn64
        Type: System.Boolean
        True to use 32 bit runtime for execution on a 64-bit server; otherwise, false.

        referenceUsage
        Type: Microsoft.SqlServer.Management.IntegrationServices.PackageInfo.ReferenceUsage
        The reference usage.
        
        reference
        Type: Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference
        The reference to the Environment used to validate the package.
    #>

    # Reference IS Catalog Environment
    $EnvironmentRef = $Project.References.Item($ISCatalogEnvironmentName, $Folder.Name)    
    $EnvironmentRef.Refresh()

    # Args: use32RuntimeOn64, ReferenceUsage,  EnvironmentReference                                              
    $OperationId = $Project.Validate($false, [Microsoft.SqlServer.Management.IntegrationServices.PackageInfo+ReferenceUsage]::SpecifyReference, $EnvironmentRef)
             
    # Validation Start Time                        
    $StartTime = Get-Date

    Write-Host ("Validation Operation ID: " + $OperationId)

    $Catalog.Operations.Refresh()
    $Operation = $Catalog.Operations[$OperationId]

    if ($Operation)
    {
        Do
        {
            Start-Sleep -s 10
            $Catalog.Operations.Refresh()
            $Operation = $Catalog.Operations[$OperationId]

            switch ($Operation.Status) {
                Running {$TimeText = "Elapsed Time"}
                Success {$TimeText = "Completed In"}
                default {$TimeText = "Ended In"}
            }            

            $ElapsedTime = New-TimeSpan –Start $StartTime –End (Get-Date)
            Write-Host ("Validation Status: " + $Operation.Status + "  (" + $TimeText + ": " + $ElapsedTime.Hours.ToString() + "h " + $ElapsedTime.Minutes.ToString() + "m " + $ElapsedTime.Seconds.ToString() + "s)")

        } While ($Operation.Status –eq "Running")
    }
    else
    {
        Write-Host ("OperationID could not be found for the validation of IS Catalog Project '" + $SSISPackageName + "'.")
    }
}

