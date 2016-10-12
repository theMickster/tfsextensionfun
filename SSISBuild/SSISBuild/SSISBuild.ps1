Param(
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $solution,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $VisualStudioVersion,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $buildtype,
    [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $buildConfiguration
)
 
Write "Entering script SSISBuild.ps1"
Write "Visual Studio Solution to Build: $solution"
Write "Visual Studio Version: $VisualStudioVersion"

$ErrorActionPreference = "Stop"
 
if ($solution.Contains("*") -or $solution.Contains("?")) 
   { 
       Write  "Pattern found in solution parameter. Calling Find-Files." 
       Write  "Find-Files -SearchPattern $solution" 
       $solutionFiles = Find-Files -SearchPattern $solution 
       Write "solutionFiles = $solutionFiles" 
   } 
   else 
   { 
       Write "No Pattern found in solution parameter." 
       $solutionFiles = ,$solution 
   } 
Write 'Determining the required Visual Studio version...'
$work_vsVersion = $null
$VisualStudioLocation = $null

switch ($VisualStudioVersion)
{
  "vs2012" {$work_vsVersion = "11.0"}
  "vs2013" {$work_vsVersion = "12.0"}
  "vs2015" {$work_vsVersion = "14.0"}
}
$VisualStudioLocation = Get-VisualStudioPath -Version $work_vsVersion 
$VisualStudioLocation += "\Common7\IDE\devenv.com"
 
Write "Visual Studio Executable Location: $VisualStudioLocation"
 
if(!$VisualStudioLocation)
{
    Write-Error "Can not find required Visual Studio version ($work_vsVersion)"
}
 
foreach ($sf in $solutionFiles) 
{
    write "Building solution: $sf"    
    write "Build arguments: $buildType $buildConfiguration"    
    $argsList = $sf + " " + $buildType + " " + $buildConfiguration
    $result = Invoke-Tool -Path $VisualStudioLocation -Argument $argsList
    $arr_result =  $result -split "\r\n"
    foreach ($line in $arr_result)
    {
        Write $line
    }
 
    # Error if there are no project built.
    if($arr_result[-1].Contains("0 succeeded or up-to-date"))
    {
        Write-Error "Zero build success means that an error occured. Please look at the build report for the build: $env:BUILD_BUILDNUMBER."
    }
 }
 
Write "Exiting script SSISBuild.ps1."