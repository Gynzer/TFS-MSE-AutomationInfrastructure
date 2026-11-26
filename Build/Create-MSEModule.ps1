# Create-MSEModule.ps1
<#
    .SYNOPSIS
       This script is designed to take the functions built within Git for the MSEAutomation Project and build a single Module.

    .DESCRIPTION
       This script is designed to take the functions built within Git for the MSEAutomation Project and build a single Module.

      NOTE: Because these functions are all designed to work together within the MSEAutomation environment 
      we have made a concious decision to divert from the normal <verb>-<noun> naming convention
      with PowerShell to <verb>-MSE<noun>.    In this way we can distinguish our purpose built functions
      with other that are available.   While most of our functions can stand alone, they are designed
      for the specific needs of this project.
 
    .PARAMETER
      None
 
    .EXAMPLE
      This script is hard coded for this project.    It should be run from the .\Build directory where it can read the .\MSEBuildEnvironment.ps1 file.

      Powershell .\Create-MSEModule.ps1

    .NOTES
 
        ScriptName   : Create-MSEModule.ps1
        Created by   : Ron Gines
        Date Coded   : 04/15/2021 10:01:10
 
    .LINK
 
        https://github.com/Ron-Gines/TFS-MSE-AutomationInfrastructure
 
 #>

Function Get-MSEUniqueTimeStamp
{
   [CmdletBinding(SupportsShouldProcess=$True)]
   Param ([Parameter(Mandatory=$false)][string]$LogPath)
   
   # Clean up variables and define in-house variables
   $FunctionName  = "Get-MSEUniqueTimeStamp"
   
   If ($LogPath -ne $null)
   {
      If ($LogPath) {Write-MSELogFile $LogPath "$($FunctionName): -------------------------------------" $false}
      If ($LogPath) {Write-MSELogFile $LogPath "$($FunctionName): >>>>>Loading" $false}
   }
   $CurrentDate = Get-Date -format g
   $DateSplit = $CurrentDate -split "/"
   $xMo = $DateSplit[0]
   if ($xMo.length -eq 1){$xMo = "0$xMo"}
   $xDa = $DateSplit[1]
   if ($xDa.length -eq 1){$xDa = "0$xDa"}
   $DateSplit2 = $DateSplit[2] -split " "
   $xYe = $DateSplit2[0]
   $AMPM = $DateSplit2[2]
   $DateSplit3 = $DateSplit2[1] -split ":"
   $UniqueDate = $xYe+$xMo+$xDa+"."+$DateSplit3[0]+$DateSplit3[1]+$AMPM
   return $UniqueDate

} # End function Get-MSEUniqueTimeStamp
#Load Module Build Environment Variables
. .\MSEBuildEnvironment.ps1

# Clear-Host
$CommandPath               = $PSCommandPath                                                          # Full Path to this script in the Build subdirectory.
$MSEReleaseNotesFile       = $RepositoryRootPath  + '\' + $ReleaseNotesFile
$MSEReleaseDirectory       = $RepositoryRootPath  + '\' + $ReleaseDirectory

$PublicFunctionPath        = @()
ForEach ($Dir in $PublicFunctionsDirectory) {
	$PublicFunctionPath   += $RepositoryRootPath + '\' + $dir
	}

$PrivateFunctionPath       = @()
ForEach ($Dir in $PrivateFunctionsDirectory) {
	$PrivateFunctionPath  += $RepositoryRootPath + '\' + $dir
	}

$PublicFunctions           = $PublicFunctionPath | Get-ChildItem -Filter *.ps1 -Recurse
$FunctionsToExport         = $PublicFunctions.BaseName
$PrivateFunctions          = $PrivateFunctionPath | Get-ChildItem -Filter *.ps1 -Recurse
$FunctionsToExclude        = $PrivateFunctions.BaseName
$AllFunctions              = $PublicFunctions + $PrivateFunctions

# Building Module psm1 file contents
$fHeader1 = "##################################################################################################################################################"
$fHeader4 = "##################################################################################################################################################"
$CompiledFunctions = ”"
foreach ($Function in $AllFunctions) {
   $MyDir                 = $Function.DirectoryName
   $MyPath                = $MyDir + "\" + $($Function.Name) 
   $MyLogicalPath         = $($MyPath -split 'GitHub')[1]
   $fHeader2              = "# Sourced from file named:"
   $fHeader3              = "#       .$MyLogicalPath"
   $CompiledFunctions     = $CompiledFunctions + [environment]::newline + [environment]::newline 
   $CompiledFunctions     = $CompiledFunctions + $fHeader1 + [environment]::newline 
   $CompiledFunctions     = $CompiledFunctions + $fHeader2 + [environment]::newline 
   $CompiledFunctions     = $CompiledFunctions + $fHeader3 + [environment]::newline 
   $CompiledFunctions     = $CompiledFunctions + $fHeader4 + [environment]::newline 
   $CompiledFunctions     = $CompiledFunctions + [string]::join([environment]::newline, (get-content -Path $Function.fullname))
}

$mFooter                  = " " + [environment]::newline + [environment]::newline + "Export-ModuleMember *" + [environment]::newline
$CompiledFunctions        = $CompiledFunctions + $mFooter

# Get our version from the Release_Notes file
# Version for when Text is required
$MyVersion                = (Get-Content $MSEReleaseNotesFile | Select-String -Pattern '.*v(\d+(\.\d+){1,4}).*' ).matches[0].groups[1].value
# Version when an object is required.
$ModuleVersion            = [System.Version]::Parse($MyVersion)

# Create Build Target Directory
$BuildTargetDirectory     = $RepositoryRootPath + '\' + $ReleaseDirectory + '\v' + $MyVersion

#Define our target file names
$MSEModuleFileName        = $BuildTargetDirectory + '\' + $ModuleToBuild + '.psm1'
$MSEModuleManifestName    = $BuildTargetDirectory + '\' + $ModuleToBuild + '.psd1'

#Check if we need to rename the existing version directory
If (Test-Path -Path $BuildTargetDirectory){
	$ExtendedDate = Get-MSEUniqueTimeStamp
	$NewBuildTargetDirectory = $BuildTargetDirectory + '-' + $ExtendedDate
	Rename-Item  $BuildTargetDirectory  $NewBuildTargetDirectory 
}

#Create our new version directory
New-Item -Path $BuildTargetDirectory -ItemType Directory > $null

# Writing out Module File
Set-Content -Path $MSEModuleFileName -Value $CompiledFunctions -Encoding UTF8 -Force

# Building Module psd1 file 
$MyManifest = @{
	Path                  = $MSEModuleManifestName
	RootModule            = Split-Path $MSEModuleFileName -leaf
	CompanyName           = $ModuleCompanyName
	Author                = $ModuleAuthor
	ModuleVersion         = $ModuleVersion
	Copyright             = $ModuleCopyRight
	Description           = $ModuleDescription
	ReleaseNotes          = $ReleaseNotesFile
	FunctionsToExport     = $FunctionsToExport

}

New-ModuleManifest @MyManifest

If ($ModuleIncludeFiles.count -gt 0){
   ForEach ($File in $ModuleIncludeFiles){
      $MyIncludeFile = $RepositoryRootPath  + '\' + $File
      If (Test-Path $MyIncludeFile) {
         Copy-Item -Path $MyIncludeFile -Destination $BuildTargetDirectory
      }
      Else
      {
         Write-Host "$MyIncludeFile could not be found.   Not included in package."
      }
   }
}


          
